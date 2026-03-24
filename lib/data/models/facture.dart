
import 'package:pda/data/models/facture_details.dart';
import 'package:pda/data/models/status.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/facture.dart';




class FactureModel{
  int? id;
  DateTime? dateFacture;
  DateTime? dateCreation;
  double? totalHt;
  double? totalTTC;
  double? totalTva;
  double? montantRestant;
  StatusModel? status;
  List<FactureDetailModel>? details;

  FactureModel({
    this.id,
    this.dateFacture,
    this.dateCreation,
    this.totalHt,
    this.totalTTC,
    this.totalTva,
    this.status,
    this.details,
    this.montantRestant
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'dateLaivraison': this.dateFacture,
      'dateCreation': this.dateCreation,
      'totalHt': this.totalHt,
      'totalTTC': this.totalTTC,
      'totalTva': this.totalTva,
      'status': this.status,
      'details': this.details,

    };
  }

  factory FactureModel.fromMap(Map<String, dynamic> json) {

    return FactureModel(
      id: json['id'] as int,
      dateFacture: json["dateFacture"]==null?null:DateTime.parse(json['dateFacture']),
      dateCreation: json['dateCreation']==null?null:DateTime.parse(json['dateCreation']),
      totalHt: json['totalHt'] ,
      totalTTC: json['totalTTC']  ,
      totalTva: json['totalTva']  ,
      montantRestant: json['montantRestant'],
      status: json['status'] ==null?null:StatusModel.fromMap(json['status']) ,
      details: json['details'] ==null?null:(json['details'] as List).map((e) => FactureDetailModel.fromJson(e)).toList() ,
    );
  }

  FactureEntity toEntity(){
    return FactureEntity(
      id: id,
      status: status?.toEntity(),
      dateCreation: dateCreation,
      dateFacture: dateFacture,
      totalHt: totalHt,
      totalTTC: totalTTC,
      totalTva: totalTva,
      montantRestant: montantRestant,
      details: details?.map((e) => e.toEntity()).toList()
    );
  }




}

