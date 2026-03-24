part of 'clients_bloc.dart';

@immutable
abstract class ClientsEvent {}


class FetchData extends ClientsEvent{

}

class FetchTypes extends ClientsEvent{

}
class SelectType extends ClientsEvent{
  TypeClientEntity typeClientEntity;

  SelectType(this.typeClientEntity);
}

class AddClient extends ClientsEvent{
  String nom;

  AddClient(this.nom);
}
