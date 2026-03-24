part of 'retour_bloc.dart';



class RetourState {

  AppStatus? fetchData;
  String? error;
  List<RetourEntity>? retours;
  bool? isOffline;

  RetourState({
    this.fetchData,
    this.error,
    this.retours,
    this.isOffline,
  });

  RetourState copyWith({
    AppStatus? fetchData,
    String? error,
    List<RetourEntity>? retours,
    bool? isOffline,
  }) {
    return RetourState(
      fetchData: fetchData ?? this.fetchData,
      error: error ,
      retours: retours ?? this.retours,
      isOffline: isOffline ,
    );
  }
}

