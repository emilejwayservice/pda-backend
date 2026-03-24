part of 'add_command_bloc.dart';



class AddCommandState {

  AppStatus? fetchClientsStatus;
  AppStatus? fetchProductsStatus;
  AppStatus? cartStatus;
  AppStatus? addCommandStatus;
  String? error;
  List<ClientEntity>? clients;
  List<ProductEntity>? products;
  List<ProductEntity>? displayedProducts;
  List<TvaEntity>? tvas;
  bool? isOffline;
  DateTime? dateCommand;
  DateTime? dateLivraisonPrevu;
  ClientEntity? selectedClient;

  AddCommandState({
    this.fetchClientsStatus,
    this.fetchProductsStatus,
    this.error,
    this.clients,
    this.products,
    this.isOffline,
    this.dateLivraisonPrevu,
    this.dateCommand,
    this.selectedClient,
    this.displayedProducts,
    this.cartStatus,
    this.tvas,
    this.addCommandStatus
  });

  List<ProductEntity> getSelectedProducts(){
    List<ProductEntity> selectedProd=products!.where((element) => element.isSelected).toList();
    return selectedProd;
  }

  int get nbSelectedProds{
    List<ProductEntity>? prods=products?.where((element) => element.isSelected).toList();
    return (prods?.length??0);
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
  AddCommandState copyWith({
    AppStatus? fetchClientsStatus,
    AppStatus? fetchProductsStatus,
    AppStatus? addCommandStatus,
    AppStatus? cartStatus,
    String? error,
    List<ClientEntity>? clients,
    List<ProductEntity>? products,
    List<ProductEntity>? displayedProducts,
    List<TvaEntity>? tvas,
    bool? isOffline,
    DateTime? dateCommand,
    DateTime? dateLivraisonPrevu,
    ClientEntity? selectedClient,

  }) {
    return AddCommandState(
      fetchClientsStatus: fetchClientsStatus ?? this.fetchClientsStatus,
      fetchProductsStatus: fetchProductsStatus ?? this.fetchProductsStatus,
      error: error ?? this.error,
      clients: clients ?? this.clients,
      products: products ?? this.products,
      isOffline: isOffline ?? this.isOffline,
      dateLivraisonPrevu: dateLivraisonPrevu ?? this.dateLivraisonPrevu,
      dateCommand: dateCommand ?? this.dateCommand,
      selectedClient: selectedClient ?? this.selectedClient,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      cartStatus: cartStatus,
      tvas: tvas ?? this.tvas,
      addCommandStatus: addCommandStatus
    );
  }
}

