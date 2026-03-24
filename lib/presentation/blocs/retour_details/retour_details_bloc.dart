import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';

import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/retour.dart';

part 'retour_details_event.dart';
part 'retour_details_state.dart';

class RetourDetailsBloc extends Bloc<RetourDetailsEvent, RetourDetailsState> {
  RetourDetailsBloc(int id) : super(RetourDetailsState(retourId: id)) {
    on<FetchData>(_fetchData);
    on<Livrer>(_livrer);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<RetourDetailsState> emit) async{
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      RetourEntity retour=await repository.getRetourDetails(state.retourId!);
      emit(state.copyWith(fetchData: AppStatus.success,retour: retour));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error));
      rethrow;
    }
  }

  FutureOr<void> _livrer(Livrer event, Emitter<RetourDetailsState> emit)async {
    try{
      emit(state.copyWith(livraisonStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      RetourEntity retour=await repository.livrerRetour(state.retourId!);
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateRetours());
      emit(state.copyWith(livraisonStatus: AppStatus.success,retour: retour));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(livraisonStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(livraisonStatus: AppStatus.error));
      rethrow;
    }
  }
}
