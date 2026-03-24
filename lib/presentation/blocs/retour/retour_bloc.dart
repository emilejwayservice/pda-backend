import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../domain/entities/retour.dart';
import '../core_bloc/core_bloc.dart';

part 'retour_event.dart';
part 'retour_state.dart';

class RetourBloc extends Bloc<RetourEvent, RetourState> {
  late StreamSubscription<CoreState> streamSubscription;
  RetourBloc() : super(RetourState()) {
    on<FetchData>(_fetchData);
    CoreBloc coreBloc=Dependencies.get<CoreBloc>();
    streamSubscription=coreBloc.stream.listen(listener);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<RetourState> emit) async{
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      List<RetourEntity> retours=await repository.retours(company);
      emit(state.copyWith(fetchData: AppStatus.success,retours: retours));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error));
    }
  }

  void listener(CoreState state) {
    if(state is RetoursUpdated){
      add(FetchData());
    }
  }

  @override
  Future<void> close()async {
    // TODO: implement close
    await streamSubscription.cancel();
    await super.close();
  }
}
