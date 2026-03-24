



import 'package:pda/domain/entities/entrepot.dart';

class EntrepotModel{
  int?id;
  int?idSocite;
  String?libelle;
  String?ref;

  EntrepotModel({
    this.id,
    this.idSocite,
    this.libelle,
    this.ref,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'idSocite': this.idSocite,
      'libeller': this.libelle,
      'ref': this.ref,
    };
  }

  factory EntrepotModel.fromJson(Map<String, dynamic> map) {
    return EntrepotModel(
      id: map['id'] ,
      idSocite: map['id_societe'] ,
      libelle: map['libelle'] ,
      ref: map['ref'] ,
    );
  }

  EntrepotEntity toEntity(){
    return EntrepotEntity(
      id: id,
      libelle: libelle,
      ref: ref,
      idSocite: idSocite
    );
  }

}