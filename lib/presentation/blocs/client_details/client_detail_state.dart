part of 'client_detail_bloc.dart';


class ClientDetailState {

  int? idClient;
  AppStatus? fetchData;
  String? error;
  bool? isOffline;
  ClientEntity? client;

  ClientDetailState({
    this.idClient,
    this.fetchData,
    this.error,
    this.isOffline,
    this.client,
  });

  ClientDetailState copyWith({
    int? idClient,
    AppStatus? fetchData,
    String? error,
    bool? isOffline,
    ClientEntity? client,
  }) {
    return ClientDetailState(
      idClient: idClient ?? this.idClient,
      fetchData: fetchData ?? this.fetchData,
      error: error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
      client: client ?? this.client,
    );
  }
}