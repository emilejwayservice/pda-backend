part of 'livraison_details_bloc.dart';

@immutable
abstract class LivraisonDetailsEvent {}



class FetchData extends LivraisonDetailsEvent{}


class ValiderLivraison extends LivraisonDetailsEvent{
}


class GenerateRecu extends LivraisonDetailsEvent{}
class GenerateBl extends LivraisonDetailsEvent{}

class FacturableLivraison extends LivraisonDetailsEvent{}

class SelectDevice extends LivraisonDetailsEvent{
  BluetoothDevice device;

  SelectDevice(this.device);
}




