part of 'stock_bloc.dart';



class StockState {

  AppStatus? fetchDataStatus;
  AppStatus? fetchProductsStatus;
  String? error;
  List<EntrepotEntity>? entrepots;
  List<ProductEntity>? products;
  bool? isOffline;
  EntrepotEntity? selectedEntrepot;

  StockState({
    this.fetchDataStatus,
    this.fetchProductsStatus,
    this.error,
    this.entrepots,
    this.products,
    this.isOffline,
    this.selectedEntrepot
  });

  StockState copyWith({
    AppStatus? fetchDataStatus,
    AppStatus? fetchProductsStatus,
    String? error,
    List<EntrepotEntity>? entrepots,
    List<ProductEntity>? products,
    bool? isOffline,
    EntrepotEntity? selectedEntrepot
  }) {
    return StockState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      fetchProductsStatus: fetchProductsStatus ?? this.fetchProductsStatus,
      error: error ,
      isOffline: isOffline,
      entrepots: entrepots ?? this.entrepots,
      products: products ?? this.products,
      selectedEntrepot: selectedEntrepot ?? this.selectedEntrepot
    );
  }
}

