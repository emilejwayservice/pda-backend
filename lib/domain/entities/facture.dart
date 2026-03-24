
import 'package:pda/data/models/facture_details.dart';
import 'package:pda/data/models/status.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/facture_details.dart';
import 'package:pda/domain/entities/status.dart';




class FactureEntity{
  int? id;
  DateTime? dateFacture;
  DateTime? dateCreation;
  double? totalHt;
  double? totalTTC;
  double? totalTva;
  double? montantRestant;
  double? montantToPay;
  StatusEntity? status;
  List<FactureDetailEntity>? details;

  FactureEntity({
    this.id,
    this.dateFacture,
    this.dateCreation,
    this.totalHt,
    this.totalTTC,
    this.totalTva,
    this.status,
    this.details,
    this.montantRestant,
    this.montantToPay
  });




}

