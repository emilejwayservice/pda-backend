part of 'livraison_historique_bloc.dart';



class LivraisonHistoriqueState {

  AppStatus? fetchStatus;
  String? error;
  List<LivraisonEntity>? livraisons;
  DateTime? selectedDate;
  bool? isOffline;

  LivraisonHistoriqueState({
    this.fetchStatus,
    this.error,
     this.livraisons,
    this.selectedDate,
    this.isOffline
  });

  LivraisonHistoriqueState copyWith({
    AppStatus? fetchStatus,
    String? error,
    List<LivraisonEntity>? livraisons,
    DateTime? selectedDate,
    bool? isOffline
  }) {
    return LivraisonHistoriqueState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      error: error ,
      livraisons: livraisons ?? this.livraisons,
      selectedDate: selectedDate ?? this.selectedDate,
      isOffline: isOffline
    );
  }
}

