

import 'package:pda/domain/entities/client_reglement_req.dart';

class ClientRegReqModel{
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
   List<Map<String,dynamic>>? factures;

   ClientRegReqModel({
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

   Map<String, dynamic> toJson() {
    return {
      'mode': this.mode,
      'dateEcheance': this.dateEcheance,
      'dateReglement': this.dateReglement,
      'montant': this.montant,
      'avance': this.avance,
      'numero': this.numero,
      'banque': this.banque,
      'caisse': this.caisse,
      'clientId': this.clientId,
      'company': this.company,
      'factures': this.factures,
    };
  }

  static ClientRegReqModel toModel(ClientRegReqEntity regReqEntity){
     return ClientRegReqModel(
       clientId: regReqEntity.clientId,
       banque: regReqEntity.banque,
       company: regReqEntity.company,
       numero: regReqEntity.numero,
       caisse: regReqEntity.caisse,
       dateEcheance: regReqEntity.dateEcheance,
       dateReglement: regReqEntity.dateReglement,
       mode: regReqEntity.mode,
       montant: regReqEntity.montant,
       avance: regReqEntity.montant,
       factures: regReqEntity.factures,
     );
  }




}