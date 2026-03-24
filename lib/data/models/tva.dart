



import 'package:pda/domain/entities/tva.dart';

class TvaModel{
  int? id;
  String? titre;
  int? taux;

  TvaModel({
    this.id,
    this.titre,
    this.taux,
  });



  factory TvaModel.fromJson(Map<String, dynamic> json) {
    return TvaModel(
      id: json['id'] as int,
      titre: json['titre'] as String,
      taux: json['taux'] as int,
    );
  }

  TvaEntity toEntity(){
    return TvaEntity(
      id: id,
      taux: taux,
      titre: titre
    );
  }
}