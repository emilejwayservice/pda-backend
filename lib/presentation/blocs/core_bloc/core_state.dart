part of 'core_bloc.dart';

@immutable
abstract class CoreState {}

class CoreInitial extends CoreState {}


class ChargementUpdated extends CoreState{}

class ClientsUpdated extends CoreState{}

class CommandsUpdated extends CoreState{}

class LivraisonsUpdated extends CoreState{}

class RetoursUpdated extends CoreState{}

