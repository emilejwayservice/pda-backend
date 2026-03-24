part of 'ventes_direct_bloc.dart';




class VentesDirectState {

  AppStatus? fetchDataStatus;
  AppStatus? fetchProductsStatus;
  AppStatus? cartStatus;
  AppStatus? addVenteStatus;
  List<ProductEntity>? displayedProducts;
  String? error;
  bool? isOffline;
  List<ClientEntity>? clients;
  List<TvaEntity>? tvas;
  List<ProductEntity>? products;
  DateTime? dateLivraison;
  ClientEntity? selectedClient;

  VentesDirectState({
    this.fetchDataStatus,
    this.error,
    this.isOffline,
    this.clients,
    this.tvas,
    this.products,
    this.dateLivraison,
    this.selectedClient,
    this.fetchProductsStatus,
    this.displayedProducts,
    this.cartStatus,
    this.addVenteStatus
  });


  VentesDirectState copyWith({
    AppStatus? fetchDataStatus,
    AppStatus? fetchProductsStatus,
    AppStatus? cartStatus,
    AppStatus? addVenteStatus,
    List<ProductEntity>? displayedProducts,
    String? error,
    bool? isOffline,
    List<ClientEntity>? clients,
    List<TvaEntity>? tvas,
    List<ProductEntity>? products,
    DateTime? dateLivraison,
    ClientEntity? selectedClient,
  }) {
    return VentesDirectState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      error: error ,
      isOffline: isOffline ,
      clients: clients ?? this.clients,
      tvas: tvas ?? this.tvas,
      products: products ?? this.products,
      dateLivraison: dateLivraison ?? this.dateLivraison,
      selectedClient: selectedClient ?? this.selectedClient,
      fetchProductsStatus: fetchProductsStatus ?? this.fetchProductsStatus,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      cartStatus: cartStatus,
      addVenteStatus: addVenteStatus
    );
  }

  double get totalHt{
    double ht=0;
    List<ProductEntity> selectedProducts=getSelectedProducts();
    selectedProducts.forEach((element) {ht+=element.ht;});
    return ht;
  }

  double get totalTTC{
    double ttc=0;
    List<ProductEntity> selectedProducts=getSelectedProducts();
    selectedProducts.forEach((element) {ttc+=element.ttc;});
    return ttc;
  }

  int get nbSelectedProds{
    List<ProductEntity>? prods=products?.where((element) => (element.quantity??0)>0).toList();
    return (prods?.length??0);
  }

  List<ProductEntity> getSelectedProducts(){
    List<ProductEntity> selectedProd=products!.where((element) => (element.quantity??0)>0).toList();
    return selectedProd;
  }

}

