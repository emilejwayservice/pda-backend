part of 'add_retour_bloc.dart';

@immutable
abstract class AddRetourEvent {}

class FetchData extends AddRetourEvent{}

class SelectDate extends AddRetourEvent{
  DateTime date;

  SelectDate(this.date);
}

class SelectClient extends AddRetourEvent{
  ClientEntity client;

  SelectClient(this.client);
}

class SelectEntrepot extends AddRetourEvent{
  EntrepotEntity entrepot;

  SelectEntrepot(this.entrepot);
}

class Valider extends AddRetourEvent{
  String cause;

  Valider(this.cause);
}

class SelectLivraison extends AddRetourEvent{
  LivraisonEntity livraison;

  SelectLivraison(this.livraison);
}


