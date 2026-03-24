import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/domain/entities/activity_client.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/exceptions/server_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';
import '../../../domain/entities/type_client.dart';

part 'add_client_event.dart';
part 'add_client_state.dart';

class AddClientBloc extends Bloc<AddClientEvent, AddClientState> {
  AddClientBloc() : super(AddClientState()) {
    on<FetchData>(_fetchData);
    on<SelectType>(_selectClientType);
    on<SelectActivity>(_selectClientActivity);
    on<AddClient>(_addClient);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<AddClientState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      var result=await Future.wait(
        [
            repository.getTypesClients(),
            repository.getClientActivities()
        ]
      );
      List<TypeClientEntity> clientTypes=result[0] as List<TypeClientEntity>;
      List<ActivityClientEntity> clientActivities=result[1] as List<ActivityClientEntity>;
      emit(state.copyWith(fetchDataStatus: AppStatus.success,types: clientTypes,activities: clientActivities));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
      rethrow;
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
      rethrow;
    }

  }

  FutureOr<void> _selectClientActivity(SelectActivity event, Emitter<AddClientState> emit) {
    emit(state.copyWith(selectedActivity: event.selectedActivity));
  }

  FutureOr<void> _selectClientType(SelectType event, Emitter<AddClientState> emit) {
    emit(state.copyWith(selectedType: event.selectedType));
  }

  FutureOr<void> _addClient(AddClient event, Emitter<AddClientState> emit)async {
    try{
      emit(state.copyWith(addClientStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      ClientEntity client=ClientEntity(
        nom: event.nom,
        address: event.address,
        city: event.ville,
        tel: event.tel,
        email: event.email,
        typeClient: state.selectedType!.id,
        activityClient: state.selectedActivity!.id
      );
      await repository.addClient(client);
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateClients());
      emit(state.copyWith(addClientStatus: AppStatus.success));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(addClientStatus: AppStatus.error,isOffline: true));
    }on ServerException catch(ex){
      emit(state.copyWith(addClientStatus: AppStatus.error,error: ex.toString()));
    }catch(ex){
      emit(state.copyWith(addClientStatus: AppStatus.error));
    }
  }
}
