import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/entities/type_client.dart';
import '../core_bloc/core_bloc.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {

  StreamSubscription<CoreState>? streamSubscription;

  ClientsBloc() : super(ClientsState.empty()) {
    on<FetchData>(_fetchData);
    on<FetchTypes>(_fetchTypes);
    on<SelectType>(_selectType);
    on<AddClient>(_addClient);
    CoreBloc coreBloc=Dependencies.get<CoreBloc>();
    streamSubscription=coreBloc.stream.listen(listenner);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<ClientsState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      UserEntity currentUser=Dependencies.get<UserEntity>();
      SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
      int company=sharedPrefService.getValue(SharedPrefService.company,0);
      List<ClientEntity> clients=await repository.getClients(company);
      emit(state.copyWith(fetchDataStatus: AppStatus.success,clients: clients));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,));
      rethrow;
    }
  }

  FutureOr<void> _fetchTypes(FetchTypes event, Emitter<ClientsState> emit) async{
    try{
      emit(state.copyWith(fetchDataTypesStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      List<TypeClientEntity> typeClient=await repository.getTypesClients();
      emit(state.copyWith(fetchDataTypesStatus: AppStatus.success,types: typeClient));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataTypesStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataTypesStatus: AppStatus.error,));
      rethrow;
    }
  }

  FutureOr<void> _selectType(SelectType event, Emitter<ClientsState> emit) {
    emit(state.copyWith(selectedType: event.typeClientEntity));
  }

  FutureOr<void> _addClient(AddClient event, Emitter<ClientsState> emit) async{
    try{
      emit(state.copyWith(addClientStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      UserEntity user=Dependencies.get<UserEntity>();
      await repository.addClient(ClientEntity(userId:user.id,fkCategoryPrice: state.selectedType!.id,numero: event.nom ));
      emit(state.copyWith(addClientStatus: AppStatus.success));
      add(FetchData());
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(addClientStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(addClientStatus: AppStatus.error,));
    }
  }

  void listenner(CoreState state) {
    if(state is ClientsUpdated){
      print("=========================================================update clients");
      add(FetchData());
    }
  }

  @override
  Future<void> close()async{
    await streamSubscription?.cancel();
  }
}
