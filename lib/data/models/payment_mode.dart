


import 'package:pda/domain/entities/payment_mode.dart';

class PaymentModeModel{
  int? id;
  String? code;
  String? libelle;
  String? reference;

  PaymentModeModel({
    this.id,
    this.code,
    this.libelle,
    this.reference
  });



  factory PaymentModeModel.fromJson(Map<String, dynamic> json) {
    return PaymentModeModel(
      id: json['id'] ,
      code: json['code'] ,
      libelle: json['libelle'],
      reference: json['reference']
    );
  }

  PaymentModeEntity toEntity(){
    return PaymentModeEntity(
      id: id,
      code: code,
      libelle: libelle,
      reference: reference
    );
  }

}