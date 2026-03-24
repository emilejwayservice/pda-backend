import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/data/models/status.dart';
import 'package:pda/domain/entities/Livraison.dart';

import 'client.dart';
import 'livraison_details.dart';

class LivraisonModel {
  int? id;
  DateTime? dateLaivraison;
  DateTime? dateCreation;
  double? totalHt;
  double? totalTTC;
  double? totalTva;
  StatusModel? status;
  ClientModel? client;
  List<LivraisonDetailModel>? details;
  int? idCompany;
  int? idEntrepot;
  int? idClient;

  LivraisonModel(
      {this.id,
      this.dateLaivraison,
      this.dateCreation,
      this.totalHt,
      this.totalTTC,
      this.totalTva,
      this.status,
      this.details,
      this.client});

  LivraisonModel.fromEntity(
      {this.idCompany,
      this.idClient,
      this.idEntrepot,
      this.dateLaivraison,
      this.details});

  Map<String, dynamic> toJson() {
    return {
      'societe_id': idCompany,
      'fk_soc': idClient,
      'fk_entrepot': idEntrepot,
      'date_commande': dateLaivraison?.formattedDateEn,
      'products': details?.map((e) => e.toJson()).toList()
    };
  }

  factory LivraisonModel.fromMap(Map<String, dynamic> json) {
    return LivraisonModel(
      id: json['id'] as int,
      dateLaivraison: json["dateLaivraison"] == null
          ? null
          : DateTime.parse(json['dateLaivraison']),
      dateCreation: json['dateCreation'] == null
          ? null
          : DateTime.parse(json['dateCreation']),
      totalHt: json['totalHt'],
      totalTTC: json['totalTTC'],
      totalTva: json['totalTva'],
      status:
          json['status'] == null ? null : StatusModel.fromMap(json['status']),
      client:
          json['client'] == null ? null : ClientModel.fromJson(json['client']),
      details: json['details'] == null
          ? null
          : (json['details'] as List)
              .map((e) => LivraisonDetailModel.fromMap(e))
              .toList(),
    );
  }

  LivraisonEntity toEntity() {
    return LivraisonEntity(
        id: id,
        status: status?.toEntity(),
        dateCreation: dateCreation,
        dateLaivraison: dateLaivraison,
        totalHt: totalHt,
        totalTTC: totalTTC,
        totalTva: totalTva,
        client: client?.toEntity(),
        details: details?.map((e) => e.toEntity()).toList());
  }

  static LivraisonModel toModel(LivraisonEntity liv) {
    return LivraisonModel.fromEntity(
        dateLaivraison: liv.dateLaivraison,
        idCompany: liv.idCompany,
        idEntrepot: liv.idEntrepot,
        idClient: liv.idClient,
        details:
            liv.details?.map((e) => LivraisonDetailModel.toModel(e)).toList());
  }
}
