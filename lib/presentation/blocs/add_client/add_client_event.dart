part of 'add_client_bloc.dart';

@immutable
abstract class AddClientEvent {}

class FetchData extends AddClientEvent{}


class SelectType extends AddClientEvent{
  TypeClientEntity? selectedType;

  SelectType(this.selectedType);
}


class SelectActivity extends AddClientEvent{
  ActivityClientEntity? selectedActivity;

  SelectActivity(this.selectedActivity);
}

class AddClient extends AddClientEvent{
  String? nom;
  String? email;
  String? address;
  String? ville;
  String? tel;

  AddClient(this.nom, this.email, this.address, this.ville, this.tel);
}
