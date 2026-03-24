part of 'ventes_direct_bloc.dart';

@immutable
abstract class VentesDirectEvent {}

class FetchData extends VentesDirectEvent{}

class SelectDate extends VentesDirectEvent{
  DateTime? selectedDate;

  SelectDate(this.selectedDate);
}

class SelectClient extends VentesDirectEvent{
  ClientEntity client;

  SelectClient(this.client);
}
class ProductSelected extends VentesDirectEvent{}


class CheckCartStatus extends VentesDirectEvent{}

class AddVente extends VentesDirectEvent{}