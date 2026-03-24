part of 'livraison_details_bloc.dart';



class LivraisonDetailsState {

  AppStatus? fetchData;
  AppStatus? generatePdfStatus;
  AppStatus? facturableStatus;
  AppStatus? validerLivraisonStatus;
  AppStatus? bluetoothSrviceReadyStatus;
  bool? isPrinting;

  String? error;
  LivraisonEntity? livraison;
  bool? isOffline;
  int? livraisonId;
  List<BluetoothDevice>? devices;
  BluetoothDevice? selectedDevice;


  LivraisonDetailsState({
    this.fetchData,
    this.error,
    this.livraison,
    this.isOffline,
    this.livraisonId,
    this.validerLivraisonStatus,
    this.generatePdfStatus,
    this.facturableStatus,
    this.bluetoothSrviceReadyStatus,
    this.selectedDevice,
    this.devices,
    this.isPrinting
  });


  LivraisonDetailsState copyWith({
    AppStatus? fetchData,
    AppStatus? validerLivraisonStatus,
    AppStatus? facturableStatus,
    String? error,
    LivraisonEntity? livraison,
    bool? isOffline,
    AppStatus? generatePdfStatus,
    BluetoothService? bleutoothService,
    AppStatus? bluetoothSrviceReadyStatus,
    List<BluetoothDevice>? devices,
    BluetoothDevice? selectedDevice,
    bool? isPrinting
  }) {
    return LivraisonDetailsState(
      fetchData: fetchData ?? this.fetchData,
      error: error ,
      livraison: livraison ?? this.livraison,
      isOffline: isOffline,
      livraisonId: livraisonId,
      validerLivraisonStatus: validerLivraisonStatus,
      generatePdfStatus: generatePdfStatus,
      facturableStatus: facturableStatus,
      bluetoothSrviceReadyStatus: bluetoothSrviceReadyStatus,
      devices: devices??this.devices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isPrinting: isPrinting ?? this.isPrinting
    );
  }


}

