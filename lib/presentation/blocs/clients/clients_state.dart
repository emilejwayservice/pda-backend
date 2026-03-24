part of 'clients_bloc.dart';



class ClientsState {

  AppStatus? fetchDataStatus;
  AppStatus? fetchDataTypesStatus;
  AppStatus? addClientStatus;
  String? error;
  bool? isOffline;
  List<ClientEntity>? clients;
  List<TypeClientEntity>? types;
  TypeClientEntity? selectedType;

  ClientsState({
    this.fetchDataStatus,
    this.error,
    this.isOffline,
    this.clients,
    this.fetchDataTypesStatus,
    this.types,
    this.selectedType,
    this.addClientStatus
  });

 ClientsState.empty();



 List<ClientEntity> getTrueClients(){
   List<ClientEntity> clients=this.clients!.where((element) => !(element.isProspect??true)).toList();
   return clients;
 }
  List<ClientEntity> getProspectClients(){
    List<ClientEntity> clients=this.clients!.where((element) => (element.isProspect??true)).toList();
    return clients;
  }

  ClientsState copyWith({
    AppStatus? fetchDataStatus,
    String? error,
    bool? isOffline,
    List<ClientEntity>? clients,
    AppStatus? fetchDataTypesStatus,
    List<TypeClientEntity>? types,
    TypeClientEntity? selectedType,
    AppStatus? addClientStatus
  }) {
    return ClientsState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      error: error ,
      isOffline: isOffline ,
      clients: clients ?? this.clients,
      fetchDataTypesStatus: fetchDataTypesStatus ,
      types: types??this.types,
      selectedType: selectedType??this.selectedType,
      addClientStatus: addClientStatus
    );
  }
}

