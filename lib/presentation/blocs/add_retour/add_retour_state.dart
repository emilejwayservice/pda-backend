part of 'add_retour_bloc.dart';



class AddRetourState {

  AppStatus? fetchDataStatus;
  AppStatus? fetchProductsStatus;
  AppStatus? validerStatus;
  String? error;
  bool? isOffline;
  List<ClientEntity>? clients;
  List<EntrepotEntity>? entrepots;
  List<ProductEntity>? products;
  List<LivraisonEntity>? livraisons;
  ClientEntity? selectedClient;
  EntrepotEntity? selectedEntrepot;
  LivraisonEntity? selectedLivraison;
  DateTime? selectedDateRetour;

  AddRetourState({
    this.fetchDataStatus,
    this.error,
    this.isOffline,
    this.clients,
    this.entrepots,
    this.selectedClient,
    this.selectedEntrepot,
    this.selectedDateRetour,
    this.fetchProductsStatus,
    this.products,
    this.validerStatus,
    this.livraisons,
    this.selectedLivraison
  });

  AddRetourState copyWith({
    AppStatus? fetchDataStatus,
    AppStatus? fetchProductsStatus,
    String? error,
    bool? isOffline,
    List<ClientEntity>? clients,
    List<EntrepotEntity>? entrepots,
    List<ProductEntity>? products,
    ClientEntity? selectedClient,
    EntrepotEntity? selectedEntrepot,
    DateTime? selectedDateRetour,
    AppStatus? validerStatus,
    List<LivraisonEntity>? livraisons,
    LivraisonEntity? selectedLivraison
  }) {
    return AddRetourState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      fetchProductsStatus: fetchProductsStatus ?? this.fetchProductsStatus,
      error: error ,
      isOffline: isOffline ,
      clients: clients ?? this.clients,
      entrepots: entrepots ?? this.entrepots,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedEntrepot: selectedEntrepot ?? this.selectedEntrepot,
      selectedDateRetour: selectedDateRetour ?? this.selectedDateRetour,
      products: products ?? this.products,
      validerStatus: validerStatus,
      livraisons: livraisons ?? this.livraisons,
      selectedLivraison: selectedLivraison ?? this.selectedLivraison
    );
  }
}

