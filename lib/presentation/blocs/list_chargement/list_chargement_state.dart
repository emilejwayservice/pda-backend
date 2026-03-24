part of 'list_chargement_bloc.dart';



class ListChargementState {
  AppStatus? fetchDataStatus;
  String? error;
  List<ChargementEntity>? chargements;
  bool? isOffline;

  ListChargementState({
    this.fetchDataStatus,
    this.error,
    this.chargements,
    this.isOffline,
  });

  ListChargementState.empty();

  ListChargementState copyWith({
    AppStatus? fetchDataStatus,
    String? error,
    List<ChargementEntity>? chargements,
    bool? isOffline,
  }) {
    return ListChargementState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      error: error,
      chargements: chargements ?? this.chargements,
      isOffline: isOffline ,
    );
  }
}


