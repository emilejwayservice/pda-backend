import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/chargement.dart';
import 'package:pda/domain/entities/entrepot.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/exceptions/unauthenticated_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/product.dart';

part 'add_chargement_event.dart';
part 'add_chargement_state.dart';

class AddChargementBloc extends Bloc<AddChargementEvent, AddChargementState> {
  AddChargementBloc() : super(AddChargementState.empty()) {
   on<FetchData>(_fetchData);
   on<SelectDate>(_selectDate);
   on<SelectEntropot>(_selectEbtrepot,transformer: restartable());
   on<Recherche>(_recherche,transformer: sequential());
   on<SelectProduit>(_updateScreen,transformer: sequential());
   on<CheckCartStatus>(_checkCartStatus);
   on<SelectAllProducts>(_showAllProducts);
   on<AddChargement>(_addChargement);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<AddChargementState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
      int? idSociety=sharedPrefService.getValue(SharedPrefService.company,null);
      List<EntrepotEntity> entrepots=await repository.getListEntropot(society: idSociety!, idType: 2);
      emit(state.copyWith(fetchDataStatus: AppStatus.success,entrepot: entrepots));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  FutureOr<void> _selectDate(SelectDate event, Emitter<AddChargementState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  FutureOr<void> _selectEbtrepot(SelectEntropot event, Emitter<AddChargementState> emit) async{
    try{
      emit(state.copyWith(selectedEntrepot: event.entrepot,fetchProductsStatus: AppStatus.loading ));
      Repository repository=Dependencies.get<Repository>();
      List<ProductEntity> products=await repository.getAllProductsByEntrepot(event.entrepot.id!);
      emit(state.copyWith(fetchProductsStatus: AppStatus.success ,products: products,displayedProducts: products));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error ,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error));
    }
  }

  FutureOr<void> _recherche(Recherche event, Emitter<AddChargementState> emit) async{
      if(state.products?.isEmpty ?? true){
        return ;
      }
      if(event.query.isEmpty){
        emit(state.copyWith(displayedProducts: state.products));
        return;
      }
      List<ProductEntity> displayesProd;
      if(event.isWithName){
         displayesProd=state.products!.where((element){
          return element.labelle!.toLowerCase().contains(event.query.toLowerCase());
        }).toList();
      }else{
        displayesProd=state.products!.where((element){
          return element.code==event.query;
        }).toList();
      }

      emit(state.copyWith(displayedProducts: displayesProd));
  }



  FutureOr<void> _checkCartStatus(CheckCartStatus event, Emitter<AddChargementState> emit) async{
    if(state.products?.isEmpty ??true){
      return;
    }
    if(state.getSelectedProducts().isEmpty){
      return;
    }
    List<ProductEntity> productToCheck=state.products!.where((element) => element.quantity==null && element.isSelected,).toList();
      if(productToCheck.isNotEmpty){
        emit(state.copyWith(cartStatus: AppStatus.error,displayedProducts: productToCheck));
      }else{
        emit(state.copyWith(cartStatus: AppStatus.success));
      }
  }

  FutureOr<void> _updateScreen(SelectProduit event, Emitter<AddChargementState> emit) {
    emit(state.copyWith());
  }

  FutureOr<void> _showAllProducts(SelectAllProducts event, Emitter<AddChargementState> emit) {
    emit(state.copyWith(displayedProducts: state.products));
  }

  FutureOr<void> _addChargement(AddChargement event, Emitter<AddChargementState> emit) async{
    try{
      emit(state.copyWith(addChargementStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      UserEntity user=Dependencies.get<UserEntity>();
      SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
      int? idCompany=sharedPrefService.getValue(SharedPrefService.company, null);
      if(idCompany ==null){
        throw UnAuthenticatedException();
      }
      ChargementEntity chargement=ChargementEntity(
        userId: user.id,
        companyId: idCompany,
        dateCommand: state.selectedDate,
        entropotDetination: user.idCamion,
        entropotSource: state.selectedEntrepot!.id,
        products: state.getSelectedProducts()
      );
      await repository.addChargement(chargement);
      state.products!.forEach((element) {
        element.quantity=null;
        element.isSelected=false;
      });
      Dependencies.get<CoreBloc>().add(UpdateChargement());
      emit(state.copyWith(displayedProducts: state.products,addChargementStatus: AppStatus.success));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(addChargementStatus: AppStatus.error ,isOffline: true));
    }catch(ex){
      emit(state.copyWith(addChargementStatus: AppStatus.error));
    }
  }
}
