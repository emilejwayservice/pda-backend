part of 'retour_details_bloc.dart';



class RetourDetailsState {

  int? retourId;
  AppStatus? fetchData;
  AppStatus? livraisonStatus;
  String? error;
  RetourEntity? retour;
  bool? isOffline;

  RetourDetailsState({
    this.retourId,
    this.fetchData,
    this.error,
    this.retour,
    this.isOffline,
    this.livraisonStatus
  });

  RetourDetailsState copyWith({
    int? retourId,
    AppStatus? fetchData,
    String? error,
    RetourEntity? retour,
    bool? isOffline,
    AppStatus? livraisonStatus
  }) {
    return RetourDetailsState(
      retourId: retourId ?? this.retourId,
      fetchData: fetchData ?? this.fetchData,
      error: error ,
      retour: retour ?? this.retour,
      isOffline: isOffline ,
      livraisonStatus: livraisonStatus
    );
  }
}

