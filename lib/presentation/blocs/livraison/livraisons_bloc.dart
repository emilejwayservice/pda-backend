import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../domain/entities/Livraison.dart';
import '../core_bloc/core_bloc.dart';

part 'livraisons_event.dart';
part 'livraisons_state.dart';

class LivraisonsBloc extends Bloc<LivraisonsEvent, LivraisonsState> {

  late StreamSubscription<CoreState> streamSubscription;

  LivraisonsBloc() : super(LivraisonsState()) {
    on<FetchData>(_fetchData);
    CoreBloc coreBloc=Dependencies.get<CoreBloc>();
    streamSubscription=coreBloc.stream.listen(listener);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<LivraisonsState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      List<LivraisonEntity> livraisons=await repository.getAllLivraison(company);
      emit(state.copyWith(fetchDataStatus: AppStatus.success,livraisons: livraisons));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  void listener(CoreState state) {
      if(state is LivraisonsUpdated){
        add(FetchData());
      }
  }

  @override
  Future<void> close()async {
    await super.close();
    await streamSubscription.cancel();
  }
}
