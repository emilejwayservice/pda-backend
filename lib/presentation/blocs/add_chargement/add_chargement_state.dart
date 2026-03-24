part of 'add_chargement_bloc.dart';



class AddChargementState {

  AppStatus? fetchDataStatus;
  AppStatus? fetchProductsStatus;
  AppStatus? cartStatus;
  AppStatus? addChargementStatus;
  String? error;
  bool? isOffline;
  List<ProductEntity>? products;
  List<ProductEntity>? displayedProducts;
  List<EntrepotEntity>? entrepot;
  DateTime selectedDate=DateTime.now();
  EntrepotEntity? selectedEntrepot;
  //int nbProdSelected=0;

  AddChargementState({
    this.fetchDataStatus,
    this.error,
    this.isOffline,
    this.products,
    this.entrepot,
    required this.selectedDate,
    this.selectedEntrepot,
    this.fetchProductsStatus,
    this.displayedProducts,
    //required this.nbProdSelected,
    this.cartStatus,
    this.addChargementStatus
  });
  AddChargementState.empty();

  AddChargementState copyWith({
    AppStatus? fetchDataStatus,
    AppStatus?fetchProductsStatus,
    String? error,
    bool? isOffline,
    List<ProductEntity>? products,
    List<ProductEntity>? displayedProducts,
    List<EntrepotEntity>? entrepot,
    DateTime? selectedDate,
    EntrepotEntity? selectedEntrepot,
    //int? nbProdSelected,
    AppStatus? cartStatus,
    AppStatus? addChargementStatus

  }) {
    return AddChargementState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      fetchProductsStatus: fetchProductsStatus??this.fetchProductsStatus,
      displayedProducts: displayedProducts??this.displayedProducts,
      error: error ,
      isOffline: isOffline,
      products: products ?? this.products,
      entrepot: entrepot ?? this.entrepot,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedEntrepot: selectedEntrepot??this.selectedEntrepot,
      //nbProdSelected: nbProdSelected ?? this.nbProdSelected,
      cartStatus: cartStatus,
      addChargementStatus: addChargementStatus
    );
  }


  List<ProductEntity> getSelectedProducts(){
    List<ProductEntity> selectedProd=products!.where((element) => element.isSelected).toList();
    return selectedProd;
  }

  int get nbSelectedProds{
    List<ProductEntity>? prods=products?.where((element) => element.isSelected).toList();
    return (prods?.length??0);
  }



}


