import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/status.dart';

class LivraisonEntity {
  int? id;
  DateTime? dateLaivraison;
  DateTime? dateCreation;
  double? totalHt;
  double? totalTTC;
  double? totalTva;
  StatusEntity? status;
  ClientEntity? client;
  List<LivraisonDetailEntity>? details;
  int? idCompany;
  int? idEntrepot;
  int? idClient;

  LivraisonEntity({
    this.id,
    this.dateLaivraison,
    this.dateCreation,
    this.totalHt,
    this.totalTTC,
    this.totalTva,
    this.status,
    this.details,
    this.client,
    this.idEntrepot,
    this.idClient,
    this.idCompany,
  });

  Map<String, dynamic> toJson() {
    return {
      "societe_id": idCompany,
      "fk_soc": idClient,
      "fk_entrepot": idEntrepot,
      "date_commande": dateLaivraison != null
          ? "${dateLaivraison!.year}-${dateLaivraison!.month.toString().padLeft(2, '0')}-${dateLaivraison!.day.toString().padLeft(2, '0')}"
          : null,
      "products": details?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}
