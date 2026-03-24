

import 'package:pda/domain/entities/type_client.dart';

class TypeClientModel{
  int? id;
  String? libelle;




  TypeClientModel({
    this.id,
    this.libelle,
  });




  factory TypeClientModel.fromJson(Map<String, dynamic> map) {
    return TypeClientModel(
      id: map['rowid'] as int,
      libelle: map['libelle'] as String,
    );
  }


  TypeClientEntity toEntity()=>TypeClientEntity(
    libelle: libelle,
    id: id
  );


}