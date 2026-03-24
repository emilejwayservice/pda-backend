part of 'client_reglement_bloc.dart';

@immutable
abstract class ClientReglementEvent {}


class FetchData extends ClientReglementEvent{}

class SelectDateReglement extends ClientReglementEvent{
  DateTime date;

  SelectDateReglement(this.date);
}

class SelectDateEcheance extends ClientReglementEvent{
  DateTime date;

  SelectDateEcheance(this.date);
}

class SelectMode extends ClientReglementEvent{
  PaymentModeEntity mode;

  SelectMode(this.mode);
}


class SelectCaisse extends ClientReglementEvent{
  CaisseEntity caisse;

  SelectCaisse(this.caisse);
}

class SelectBank extends ClientReglementEvent{
  BankEntity bank;

  SelectBank(this.bank);
}

class CalculMontant extends ClientReglementEvent{
  String? value;

  CalculMontant(this.value);
}

class ValiderReglement extends ClientReglementEvent{
  String numero;
  String montant;

  ValiderReglement(this.numero, this.montant);
}



