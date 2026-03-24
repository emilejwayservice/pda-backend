import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

part 'livraison_historique_event.dart';
part 'livraison_historique_state.dart';

class LivraisonHistoriqueBloc extends Bloc<LivraisonHistoriqueEvent, LivraisonHistoriqueState> {
  LivraisonHistoriqueBloc() : super(LivraisonHistoriqueState(selectedDate: DateTime.now())) {
    on<SelectedDate>(_onSelectDate);
  }

  FutureOr<void> _onSelectDate(SelectedDate event, Emitter<LivraisonHistoriqueState> emit) async {
    try {
      emit(state.copyWith(fetchStatus: AppStatus.loading,selectedDate: event.date));
      Repository repository=Dependencies.get<Repository>();
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      List<LivraisonEntity> livraisons=await repository.getLivraisonByDate(company, event.date.formattedDateEn);
      emit(state.copyWith(fetchStatus: AppStatus.success,livraisons: livraisons));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchStatus: AppStatus.error));
    }
  }
}
