part of 'single_command_bloc.dart';



class SingleCommandState {
  int idCommand;
  AppStatus? fetchDataStatus;
  AppStatus? validerStatus;
  AppStatus? livraisonStatus;
  CommandEntity? command;
  String? error;
  bool? isOffline;
  DateTime? dateLivraison;

  SingleCommandState({
    required this.idCommand,
    this.fetchDataStatus,
    this.command,
    this.error,
    this.isOffline,
    this.validerStatus,
    this.livraisonStatus,
    this.dateLivraison
  });


  List<CommandDetailEntity> get unDelivredCommands{
    List<CommandDetailEntity> commands=command?.details?.where((element) => (element.qtyRestante??0)>0).toList()??[];
    return commands;
  }

  SingleCommandState copyWith({
    int? idCommand,
    AppStatus? fetchDataStatus,
    AppStatus? validerStatus,
    CommandEntity? command,
    String? error,
    bool? isOffline,
    AppStatus? livraisonStatus,
    DateTime? dateLivraison
  }) {
    return SingleCommandState(
      idCommand: idCommand ?? this.idCommand,
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      command: command ?? this.command,
      error: error ,
      isOffline: isOffline ,
      validerStatus: validerStatus,
      livraisonStatus: livraisonStatus,
      dateLivraison: dateLivraison ?? this.dateLivraison
    );
  }
}

