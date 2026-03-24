import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/domain/entities/livraison_command_req.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

part 'single_command_event.dart';
part 'single_command_state.dart';

class SingleCommandBloc extends Bloc<SingleCommandEvent, SingleCommandState> {
  SingleCommandBloc(int command) : super(SingleCommandState(idCommand: command,dateLivraison: DateTime.now())) {
    on<FetchData>(_fetchData);
    on<Valider>(_valider);
    on<SelectDate>(_selectDate);
    on<LivrerCommand>(_livrerCommand);
  }

  FutureOr<void> _fetchData(FetchData event,Emitter<SingleCommandState> emit)async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      CommandEntity command=await repository.getCommand(state.idCommand);
      emit(state.copyWith(fetchDataStatus: AppStatus.success,command: command));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,));
    }
  }




  FutureOr<void> _valider(Valider event, Emitter<SingleCommandState> emit) async{
    try{
      emit(state.copyWith(validerStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      CommandEntity command=await repository.validerCommand(state.command!.id!);
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateCommands());
      coreBloc.add(UpdateClients());
      emit(state.copyWith(validerStatus: AppStatus.success,command: command));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(validerStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(validerStatus: AppStatus.error,));
    }
  }

  FutureOr<void> _selectDate(SelectDate event, Emitter<SingleCommandState> emit) {
    emit(state.copyWith(dateLivraison: event.date));
  }

  FutureOr<void> _livrerCommand(LivrerCommand event, Emitter<SingleCommandState> emit)async {
      try{
        emit(state.copyWith(livraisonStatus: AppStatus.loading));
        List<CommandDetailEntity> validDetails=state.command!.details!.where((element) => (element.qtyLivraison!=null)).toList();
        if(validDetails.length==0){
          throw Exception("vous devez entrer une quantité");
        }
        List<Map<String,dynamic>> products=[];
        validDetails.forEach(
                (element) {
                  products.add({
                    "commandDetailId":element.id,
                    "quantity":element.qtyLivraison
                  });
                }
        );
        int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
        int entrepot=Dependencies.get<UserEntity>().idCamion!;
        LivComdReqEntity livraison=LivComdReqEntity(
          dateLivraison: state.dateLivraison,
          company: company,
          entrepot: entrepot,
          command: state.command!.id,
          products: products
        );
        Repository repository=Dependencies.get<Repository>();
        CommandEntity command=await repository.livrerCommand(livraison);
        CoreBloc coreBloc=Dependencies.get<CoreBloc>();
        coreBloc.add(UpdateCommands());
        coreBloc.add(UpdateClients());
        emit(state.copyWith(livraisonStatus: AppStatus.success,command: command));
      }on NetworkConnectivityException catch(ex){
        emit(state.copyWith(livraisonStatus: AppStatus.error,isOffline: true));
      }catch(ex){
        emit(state.copyWith(livraisonStatus: AppStatus.error,error:ex.toString() ));
      }
  }
}
