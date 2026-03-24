



import 'dart:async';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';

class BluetoothService{

  late bool isConnected;
  late List<BluetoothDevice> devices;
  late BluetoothDevice selectedDevice;
  late bool isScanning;

  late StreamSubscription<List<BluetoothDevice>> _scanResultsSubscription;
  late StreamSubscription<ConnectState> _connectStateSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  void Function()? notifier;


  BluetoothService({this.notifier}){
    refresh();
  }

  void refresh(){
    _scanResultsSubscription=BluetoothPrintPlus.scanResults.listen(_scanResultsListener);
    _connectStateSubscription=BluetoothPrintPlus.connectState.listen(_connectionStateListener);
    _isScanningSubscription=BluetoothPrintPlus.isScanning.listen(_scanningListener);
  }
  void _scanResultsListener(List<BluetoothDevice> devices) {
    print("*************** devices *********${devices}*****************************");
    this.devices=devices;
    notifier?.call();
  }

  void _connectionStateListener(ConnectState connectionState) {
    print("************ state ***************${connectionState}*****************************");
    isConnected=connectionState==ConnectState.connected;
    notifier?.call();
  }

  void _scanningListener(bool isScanning) {
    print("*********** is scaning *****************${isScanning}*****************************");
    this.isScanning=isScanning;
    notifier?.call();
  }

  Future<void> startScanning()async{
    await BluetoothPrintPlus.startScan();
  }

  Future<void> connectDevice(BluetoothDevice device)async{
    selectedDevice=device;
    await BluetoothPrintPlus.connect(device);
  }

  void dispose(){
    _isScanningSubscription.cancel();
    _connectStateSubscription.cancel();
    _scanResultsSubscription.cancel();
  }


}