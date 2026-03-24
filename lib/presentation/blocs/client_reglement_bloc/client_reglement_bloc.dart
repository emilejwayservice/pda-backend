import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/bank.dart';
import 'package:pda/domain/entities/caisse.dart';
import 'package:pda/domain/entities/client_reglement_req.dart';
import 'package:pda/domain/entities/payment_mode.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/facture.dart';

part 'client_reglement_event.dart';
part 'client_reglement_state.dart';

class ClientReglementBloc extends Bloc<ClientReglementEvent, ClientReglementState> {
  ClientReglementBloc(int idClient) : super(ClientReglementState(
      clientId: idClient,
      selectedDateEcheance: DateTime.now(),
      selectedDateReglement: DateTime.now())) {
    on<FetchData>(_fetchData);
    on<SelectDateReglement>(_selectDate);
    on<SelectDateEcheance>(_selectDateEcheance);
    on<SelectMode>(_selectMode);
    on<SelectBank>(_selectBank);
    on<SelectCaisse>(_selectCaisse);
    on<CalculMontant>(_calculMontant);
    on<ValiderReglement>(_validerReglement);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<ClientReglementState> emit) async{
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      var result=await Future.wait([
        repository.getPayments(),
        repository.getBanks(),
        repository.getCaisses(),
        repository.getFacturesNotPaid(state.clientId!,company)
      ]);
      List<PaymentModeEntity> payments=result[0] as List<PaymentModeEntity>;
      List<BankEntity> banks=result[1] as List<BankEntity>;
      List<CaisseEntity> caisses=result[2] as List<CaisseEntity>;
      List<FactureEntity> factures=result[3] as List<FactureEntity>;
      double totalFactures=calculTotal(factures);
      emit(state.copyWith(fetchData: AppStatus.success,
          banks: banks,
          caisses: caisses,
          payments: payments,
          totalFactures: totalFactures,
          factures: factures));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error));
    }
  }

  double calculTotal(List<FactureEntity> factures){
    double total=0;
    factures.forEach((element) {total+=(element.montantRestant??0);});
    return total;
  }

  FutureOr<void> _selectDate(SelectDateReglement event, Emitter<ClientReglementState> emit) {
    emit(state.copyWith(selectedDateReglement: event.date));
  }

  FutureOr<void> _selectDateEcheance(SelectDateEcheance event, Emitter<ClientReglementState> emit) {
    emit(state.copyWith(selectedDateEcheance: event.date));
  }

  FutureOr<void> _selectMode(SelectMode event, Emitter<ClientReglementState> emit) {
    emit(state.copyWith(selectedMode: event.mode));
  }

  FutureOr<void> _selectBank(SelectBank event, Emitter<ClientReglementState> emit) {
    emit(state.copyWith(selectedBank: event.bank));
  }

  FutureOr<void> _selectCaisse(SelectCaisse event, Emitter<ClientReglementState> emit) {
    emit(state.copyWith(selectedCaisse: event.caisse));
  }

  FutureOr<void> _calculMontant(CalculMontant event, Emitter<ClientReglementState> emit) async{
    List<FactureEntity> factures=state.factures??[];
    factures.forEach((element) {element.montantToPay=null;});
    if(event.value?.isEmpty??true){
      emit(state.copyWith());
      return;
    }
    double total=double.parse(event.value!);
    for(FactureEntity facture in factures){
      if(total>(facture.montantRestant??0)){
        facture.montantToPay=facture.montantRestant;
        total-=(facture.montantRestant??0);
      }else{
        facture.montantToPay=total;
        total=0;
        break;
      }
    }
    emit(state.copyWith());

  }

  FutureOr<void> _validerReglement(ValiderReglement event, Emitter<ClientReglementState> emit) async{
    try{
      double totalFactures=0;
      double total=double.parse(event.montant);
      state.factures!.forEach((element) {totalFactures+=(element.montantToPay??0);});
      if(totalFactures>total){
        emit(state.copyWith(validerReglementStatus: AppStatus.warning,error: "total des facture biger thant montant"));
        return;
      }
      if(state.selectedMode==null){
        emit(state.copyWith(validerReglementStatus:AppStatus.warning,error:"Vous devez choisir le mode de paiement." ));
        return;
      }
      String mode=state.selectedMode?.reference??"";
      if((mode=="versement" || mode=="virement") && state.selectedBank==null){
        emit(state.copyWith(validerReglementStatus:AppStatus.warning,error:"Vous devez choisir la banque" ));
        return;
      }
      if( mode=="espece" && state.selectedCaisse==null){
        emit(state.copyWith(validerReglementStatus:AppStatus.warning,error:"Vous devez choisir le caisse" ));
        return;
      }
      emit(state.copyWith(validerReglementStatus: AppStatus.loading));
      List<Map<String,dynamic>> factures=[];
      for(FactureEntity facture in state.factures??[]){
        if((facture.montantToPay??0)>0){
          factures.add({
            "facture_id":facture.id,
            "mt":facture.montantToPay
          });
        }
      }
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      ClientRegReqEntity request=ClientRegReqEntity(
        montant: total,
        mode: state.selectedMode?.reference,
        factures: factures,
        dateReglement: state.selectedDateReglement?.formattedDateEn,
        dateEcheance: state.selectedDateEcheance?.formattedDateEn,
        caisse: state.selectedCaisse?.id??0,
        banque: state.selectedBank?.id??0,
        numero: event.numero,
        company:company,
        clientId: state.clientId,
      );
      Repository repository=Dependencies.get<Repository>();
      await repository.addReglement(request);
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateClients());
      emit(state.copyWith(validerReglementStatus: AppStatus.success));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(validerReglementStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(validerReglementStatus: AppStatus.error));
    }
  }
}
