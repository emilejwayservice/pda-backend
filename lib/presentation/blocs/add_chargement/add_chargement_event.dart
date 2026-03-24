part of 'add_chargement_bloc.dart';

@immutable
abstract class AddChargementEvent {}

class FetchData extends AddChargementEvent{}
class SelectDate extends AddChargementEvent{
  DateTime date;

  SelectDate(this.date);
}
class SelectEntropot extends AddChargementEvent{
  EntrepotEntity entrepot;

  SelectEntropot(this.entrepot);
}

class Recherche extends AddChargementEvent{
  String query;
  bool isWithName;

  Recherche(this.query,this.isWithName);
}
class SelectProduit extends AddChargementEvent{

}

class CheckCartStatus extends AddChargementEvent{

}
class SelectAllProducts extends AddChargementEvent{

}

class AddChargement extends AddChargementEvent{

}