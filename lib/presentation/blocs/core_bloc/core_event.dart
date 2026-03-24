part of 'core_bloc.dart';

@immutable
abstract class CoreEvent {}


class UpdateChargement extends CoreEvent{}


class UpdateClients extends CoreEvent{}

class UpdateCommands extends CoreEvent{}

class UpdateLivraison extends CoreEvent{}

class UpdateRetours extends CoreEvent{}

