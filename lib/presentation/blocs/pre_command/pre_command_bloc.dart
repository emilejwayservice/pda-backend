import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/ui/screens/pre_command/pre_command.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/entities/product.dart';

part 'pre_command_event.dart';
part 'pre_command_state.dart';

class PreCommandBloc extends Bloc<PreCommandEvent, PreCommandState> {
  PreCommandBloc() : super(PreCommandState()) {
    on<FetchData>(_fetchData);
    on<SelectClient>(_selectClient);
    on<AddProducts>(_ajouterCommand);
    on<AddCommand>(_addCommand);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<PreCommandState> emit)async{
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      List<ClientEntity> clients=await repository.getClients(company);
      List<ProductEntity> prodNotSent=await repository.getProductsNotSent();
      int count=await repository.getCountProductsNotSent();
      emit(state.copyWith(fetchData: AppStatus.success,countProdNotSent: count,clients: clients,productsNotSent: prodNotSent));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error));
      rethrow;
    }
  }

  FutureOr<void> _selectClient(SelectClient event, Emitter<PreCommandState> emit) async{
    try{
      emit(state.copyWith(fetchProductsStatus: AppStatus.loading,selectedClient: event.client));
      Repository repository=Dependencies.get<Repository>();
      List<ProductEntity> products=await repository.getProductsByClient(event.client.id!);
      emit(state.copyWith(fetchProductsStatus: AppStatus.success,products: products));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error));

    }
  }

  FutureOr<void> _ajouterCommand(AddProducts event, Emitter<PreCommandState> emit)async{
    List<ProductEntity> selectedProducts=(state.products??[]).where((element) => ((element.quantity??0)>0)).toList();
    Repository repository=Dependencies.get<Repository>();
    selectedProducts.forEach(
            (element) async{
              await repository.addProductToLocal(element);
            });
    List<ProductEntity> products=await repository.getProductsNotSent();
    int count=await repository.getCountProductsNotSent();
    selectedProducts.forEach((element) {element.quantity=0;});
    emit(state.copyWith(productsNotSent: products,countProdNotSent: count));
  }




  FutureOr<void> _addCommand(AddCommand event, Emitter<PreCommandState> emit) async{
    Repository repository=Dependencies.get<Repository>();
    await repository.updateSentProducts();
    List<ProductEntity> products=await repository.getProductsNotSent();
    int count=await repository.getCountProductsNotSent();
    emit(state.copyWith(updateSentProducts: AppStatus.success,countProdNotSent: count,productsNotSent: products));
  }
}
