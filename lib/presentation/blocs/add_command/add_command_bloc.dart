import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/domain/entities/tva.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/repository/repository.dart';
import '../../../domain/repository/repository.dart';

part 'add_command_event.dart';
part 'add_command_state.dart';

class AddCommandBloc extends Bloc<AddCommandEvent, AddCommandState> {
  AddCommandBloc() : super(AddCommandState()) {
    on<FetchData>(_fetchData);
    on<SelectClient>(_selectClient,transformer: restartable());
    on<Recherche>(_recherche,transformer: sequential());
    on<AddCommandEvent>(_selectDates);
    on<CheckCartStatus>(_checkCartStatus);
    on<SelectProduit>(_onSelectProduit,transformer: sequential());
    on<SelectAllProducts>(_showAllProducts);
    on<AddCommand>(_addCommand);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<AddCommandState> emit)async {
    try{
      emit(state.copyWith(fetchClientsStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
      int company=sharedPrefService.getValue(SharedPrefService.company, 0);
      List<ClientEntity> clients=await repository.getClients(company);
      List<TvaEntity> tvas=await repository.getTvas();
      emit(state.copyWith(fetchClientsStatus: AppStatus.success,tvas: tvas,dateCommand: DateTime.now(),dateLivraisonPrevu: DateTime.now().add(const Duration(days: 1)),clients: clients));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchClientsStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchClientsStatus: AppStatus.error));
    }
  }

  FutureOr<void> _selectClient(SelectClient event, Emitter<AddCommandState> emit) async{
    try{
      emit(state.copyWith(fetchProductsStatus: AppStatus.loading,selectedClient: event.client));
      Repository repository=Dependencies.get<Repository>();
      List<ProductEntity> products=await repository.getProductsByClient(event.client.id!);
      emit(state.copyWith(fetchProductsStatus: AppStatus.success,products: products,displayedProducts: products));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error,isOffline: true));
    }catch (ex){
      emit(state.copyWith(fetchProductsStatus: AppStatus.error));
    }
  }




  FutureOr<void> _recherche(Recherche event, Emitter<AddCommandState> emit) async{
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

  FutureOr<void> _checkCartStatus(CheckCartStatus event, Emitter<AddCommandState> emit)async {
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

  FutureOr<void> _onSelectProduit(SelectProduit event, Emitter<AddCommandState> emit) {
    emit(state.copyWith());
  }
  FutureOr<void> _showAllProducts(SelectAllProducts event, Emitter<AddCommandState> emit) {
    emit(state.copyWith(displayedProducts: state.products));
  }

  FutureOr<void> _selectDates(AddCommandEvent event, Emitter<AddCommandState> emit) {
    if(event is SelectDateCommand){
      emit(state.copyWith(dateCommand: event.dateTime));
    }else if(event is SelectDateLivraison){
      emit(state.copyWith(dateLivraisonPrevu: event.dateTime));
    }
  }

  FutureOr<void> _addCommand(AddCommand event, Emitter<AddCommandState> emit) async {
    try{
      emit(state.copyWith(addCommandStatus: AppStatus.loading));
      List<ProductEntity> selectedProducts=state.getSelectedProducts();
      SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
      Repository repository=Dependencies.get<Repository>();
      int idCompany=sharedPrefService.getValue(SharedPrefService.company, 0);
      CommandEntity command=CommandEntity(
        idClient:state.selectedClient?.id,
        dateCommand: state.dateCommand,
        dateLivraisonPrevue: state.dateLivraisonPrevu,
        idSociete: idCompany,
        details: selectedProducts.map((e) => CommandDetailEntity(product: e)).toList()
      );
      await repository.addCommand(command);
      clearEnvirement();
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateCommands());
      emit(state.copyWith(addCommandStatus: AppStatus.success));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(addCommandStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(addCommandStatus: AppStatus.error));
    }
  }

  void clearEnvirement() {
    state.products?.forEach((element) {
      element.quantity=null;
      element.setTva=0;
      element.isSelected=false;
    });
    emit(state.copyWith(dateCommand: DateTime.now(),dateLivraisonPrevu: DateTime.now().add(const Duration(days: 1))));
  }
}
