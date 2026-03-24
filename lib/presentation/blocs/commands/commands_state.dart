part of 'commands_bloc.dart';



class CommandsState {

  AppStatus? fetchDataStatus;
  String? error;
  List<CommandEntity>? commands;
  bool? isOffline;

  CommandsState({
    this.fetchDataStatus,
    this.error,
    this.commands,
    this.isOffline,
  });

  CommandsState copyWith({
    AppStatus? fetchDataStatus,
    String? error,
    List<CommandEntity>? commands,
    bool? isOffline,
  }) {
    return CommandsState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      error: error ?? this.error,
      commands: commands ?? this.commands,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

