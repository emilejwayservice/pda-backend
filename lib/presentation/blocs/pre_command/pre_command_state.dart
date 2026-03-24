part of 'pre_command_bloc.dart';


class PreCommandState {

  AppStatus? fetchData;
  AppStatus? fetchProductsStatus;
  AppStatus? updateSentProducts;
  String? error;
  List<ProductEntity>? products;
  bool? isOffline;
  ClientEntity? selectedClient;
  List<ClientEntity>? clients;
  List<ProductEntity>? productsNotSent;
  int? countProdNotSent;

  PreCommandState({
    this.fetchData,
    this.error,
    this.products,
    this.isOffline,
    this.selectedClient,
    this.clients,
    this.fetchProductsStatus,
    this.productsNotSent,
    this.countProdNotSent,
    this.updateSentProducts
  });

  PreCommandState copyWith({
    AppStatus? fetchData,
    String? error,
    List<ProductEntity>? products,
    bool? isOffline,
    List<ClientEntity>? clients,
    ClientEntity? selectedClient,
    AppStatus? fetchProductsStatus,
    List<ProductEntity>? productsNotSent,
    int? countProdNotSent,
    AppStatus? updateSentProducts,
  }) {
    return PreCommandState(
      fetchData: fetchData ?? this.fetchData,
      error: error ?? this.error,
      products: products ?? this.products,
      isOffline: isOffline ?? this.isOffline,
      selectedClient: selectedClient ?? this.selectedClient,
      clients: clients?? this.clients,
      fetchProductsStatus: fetchProductsStatus ?? this.fetchProductsStatus,
      productsNotSent: productsNotSent ?? this.productsNotSent,
      countProdNotSent: countProdNotSent ?? this.countProdNotSent,
      updateSentProducts: updateSentProducts
    );
  }


}

