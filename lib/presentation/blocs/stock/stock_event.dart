part of 'stock_bloc.dart';

@immutable
abstract class StockEvent {}


class FetchData extends StockEvent{}

class FetchProducts extends StockEvent{
  EntrepotEntity entrepot;

  FetchProducts(this.entrepot);
}

class RefetchProducts extends StockEvent{}