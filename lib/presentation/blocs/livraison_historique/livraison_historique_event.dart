part of 'livraison_historique_bloc.dart';

@immutable
abstract class LivraisonHistoriqueEvent {}


class SelectedDate extends LivraisonHistoriqueEvent{
  DateTime date;

  SelectedDate(this.date);
}
