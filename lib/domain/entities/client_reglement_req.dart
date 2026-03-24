class ClientRegReqEntity {
  String? mode;
  String? dateEcheance;
  String? dateReglement;
  double? montant;
  double? avance;
  String? numero;
  int? banque;
  int? caisse;
  int? clientId;
  int? company;
  List<Map<String, dynamic>>? factures;

  ClientRegReqEntity({
    this.mode,
    this.dateEcheance,
    this.dateReglement,
    this.montant,
    this.avance,
    this.numero,
    this.banque,
    this.caisse,
    this.clientId,
    this.company,
    this.factures,
  });
}