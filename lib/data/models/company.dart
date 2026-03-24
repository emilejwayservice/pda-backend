


import 'package:pda/domain/entities/company.dart';

class CompanyModel{
  int? id;
  String? name;
  String? city;
  String? address;
  int? activity;

  CompanyModel({
    this.id,
    this.name,
    this.city,
    this.activity,
    this.address
  });

  Map<String, dynamic> toJson() {
    return {
      'societe_ID': this.id,
      'societe_NOM': this.name,
      'societe_TOWN': this.city,
      'fk_activite': this.activity,
    };
  }

  factory CompanyModel.fromJson(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['societe_ID']       ,
      name: map['societe_NOM']    ,
      city: map['societe_TOWN']   ,
      activity: map['fk_activite'],
      address: map['societe_ADDRESS']
    );
  }
  CompanyEntity toEntity(){
    return CompanyEntity(
      id: id,
      name: name,
      activity: activity,
      city: city,
      address: address
    );
  }
}