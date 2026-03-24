



import 'package:pda/domain/entities/caisse.dart';

class CaisseModel{
  int? id;
  String? libelle;

  CaisseModel({
    this.id,
    this.libelle,
  });

  factory CaisseModel.fromJson(Map<String, dynamic> map) {
    return CaisseModel(
      id: map['id'] as int,
      libelle: map['libelle'] as String,
    );
  }

  CaisseEntity toEntity(){
    return CaisseEntity(
      libelle: libelle,
      id: id
    );
  }

}