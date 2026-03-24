import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/chargement.dart';

part 'list_chargement_event.dart';
part 'list_chargement_state.dart';

class ListChargementBloc extends Bloc<ListChargementEvent, ListChargementState> {

  late StreamSubscription<CoreState> streamSubscription;

  ListChargementBloc() : super(ListChargementState.empty()) {
   on<FetchData>(_fetchData);
   CoreBloc core=Dependencies.get<CoreBloc>();
   streamSubscription=core.stream.listen(listener);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<ListChargementState> emit)async {
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      UserEntity user=Dependencies.get<UserEntity>();
      List<ChargementEntity> chargements=await repository.getAllChargement(user.idCamion!);
      emit(state.copyWith(fetchDataStatus: AppStatus.success,chargements: chargements));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  void listener(CoreState state) {
    if(state is ChargementUpdated){
      add(FetchData());
    }
  }

  @override
  Future<void> close() async{
    await streamSubscription.cancel();
  }
}
