


import 'package:pda/domain/entities/bank.dart';

class BankModel{
  int? id;
  String? code;
  String? banque;
  String? agence;

  BankModel({
    this.id,
    this.code,
    this.banque,
    this.agence,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] as int,
      code: json['code'] as String,
      banque: json['banque'] as String,
      agence: json['agence'] as String,
    );
  }

  BankEntity toEntity(){
    return BankEntity(
      id: id,
      code: code,
      agence: agence,
      banque: banque
    );
  }

}