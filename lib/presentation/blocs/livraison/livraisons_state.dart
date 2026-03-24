part of 'livraisons_bloc.dart';



class LivraisonsState {

  AppStatus? fetchDataStatus;
  String? error;
  List<LivraisonEntity>? livraisons;
  bool? isOffline;

  LivraisonsState({
    this.fetchDataStatus,
    this.error,
    this.livraisons,
    this.isOffline,
  });

  LivraisonsState copyWith({
    AppStatus? fetchDataStatus,
    String? error,
    List<LivraisonEntity>? livraisons,
    bool? isOffline,
  }) {
    return LivraisonsState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      error: error ,
      livraisons: livraisons ?? this.livraisons,
      isOffline: isOffline ,
    );
  }
}

