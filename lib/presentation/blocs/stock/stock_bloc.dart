import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../domain/entities/entrepot.dart';
import '../../../domain/entities/product.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc() : super(StockState()) {
    on<FetchData>(_fetchData);
    on<FetchProducts>(_fetchProducts);
    on<RefetchProducts>(_refetchProducts);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<StockState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      List<EntrepotEntity> entrepots=await repository.getEntrepotsByUser();
      emit(state.copyWith(fetchDataStatus: AppStatus.success,entrepots: entrepots));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  FutureOr<void> _fetchProducts(FetchProducts event, Emitter<StockState> emit) async {
    try{
      emit(state.copyWith(fetchProductsStatus: AppStatus.loading,selectedEntrepot: event.entrepot));
      Repository repository=Dependencies.get<Repository>();
      List<ProductEntity> products=await repository.getProductsByEntrepot(event.entrepot.id!);
      emit(state.copyWith(fetchProductsStatus: AppStatus.success,products: products));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error));
    }
  }

  FutureOr<void> _refetchProducts(RefetchProducts event, Emitter<StockState> emit) {
    if(state.selectedEntrepot!=null){
      add(FetchProducts(state.selectedEntrepot!));
    }
  }
}
