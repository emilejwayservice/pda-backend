part of 'add_command_bloc.dart';

@immutable
abstract class AddCommandEvent {}


class FetchData extends AddCommandEvent{}



class SelectDateCommand extends AddCommandEvent{
  DateTime dateTime;

  SelectDateCommand(this.dateTime);
}


class SelectDateLivraison extends AddCommandEvent{
  DateTime dateTime;

  SelectDateLivraison(this.dateTime);
}

class SelectClient extends AddCommandEvent{
  ClientEntity client;

  SelectClient(this.client);
}

class Recherche extends AddCommandEvent{
  String query;
  bool isWithName;

  Recherche(this.query,this.isWithName);
}
class SelectProduit extends AddCommandEvent{

}

class CheckCartStatus extends AddCommandEvent{

}
class SelectAllProducts extends AddCommandEvent{

}

class AddCommand extends AddCommandEvent{

}