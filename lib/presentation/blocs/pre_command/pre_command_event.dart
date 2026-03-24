part of 'pre_command_bloc.dart';

@immutable
abstract class PreCommandEvent {}


class FetchData extends PreCommandEvent{}


class SelectClient extends PreCommandEvent{
  ClientEntity client;

  SelectClient(this.client);
}


class AddProducts extends PreCommandEvent{}

class AddCommand extends PreCommandEvent{}




