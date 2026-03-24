part of 'client_reglement_bloc.dart';



class ClientReglementState {
  AppStatus? fetchData;
  AppStatus? validerReglementStatus;
  String? error;
  bool? isOffline;
  List<FactureEntity>? factures;
  List<PaymentModeEntity>? payments;
  List<CaisseEntity>? caisses;
  List<BankEntity>? banks;
  int? clientId;
  DateTime? selectedDateReglement;
  DateTime? selectedDateEcheance;
  double? totalFactures;

  PaymentModeEntity? selectedMode;
  CaisseEntity? selectedCaisse;
  BankEntity? selectedBank;



  ClientReglementState({
    this.fetchData,
    this.error,
    this.isOffline,
    this.factures,
    this.payments,
    this.caisses,
    this.banks,
    this.clientId,
    this.selectedDateReglement,
    this.selectedMode,
    this.selectedCaisse,
    this.selectedBank,
    this.selectedDateEcheance,
    this.validerReglementStatus,
    this.totalFactures
  });

  ClientReglementState copyWith({
    AppStatus? fetchData,
    AppStatus? validerReglementStatus,
    String? error,
    bool? isOffline,
    List<FactureEntity>? factures,
    List<PaymentModeEntity>? payments,
    List<CaisseEntity>? caisses,
    List<BankEntity>? banks,
    int? clientId,
    DateTime? selectedDateReglement,
    DateTime? selectedDateEcheance,
    PaymentModeEntity? selectedMode,
    CaisseEntity? selectedCaisse,
    BankEntity? selectedBank,
    double? totalFactures
  }) {
    return ClientReglementState(
      fetchData: fetchData ?? this.fetchData,
      error: error ,
      isOffline: isOffline ,
      factures: factures ?? this.factures,
      payments: payments ?? this.payments,
      caisses: caisses ?? this.caisses,
      banks: banks ?? this.banks,
      clientId: clientId ?? this.clientId,
      selectedDateReglement: selectedDateReglement ?? this.selectedDateReglement,
      selectedMode: selectedMode ?? this.selectedMode,
      selectedCaisse: selectedCaisse ?? this.selectedCaisse,
      selectedBank: selectedBank ?? this.selectedBank,
      selectedDateEcheance: selectedDateEcheance ?? this.selectedDateEcheance,
      validerReglementStatus: validerReglementStatus,
      totalFactures: totalFactures ?? this.totalFactures
    );
  }
}


