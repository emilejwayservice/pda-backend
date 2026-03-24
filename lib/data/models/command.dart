import 'dart:convert';

import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/data/models/client.dart';
import 'package:pda/data/models/command_details.dart';
import 'package:pda/data/models/facture_details.dart';
import 'package:pda/data/models/status.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/entities/facture.dart';

class CommandModel {
  int? id;
  DateTime? dateCommand;
  DateTime? dateLivraisonPrevu;
  DateTime? dateCreation;
  double? totalHt;
  double? totalTTC;
  double? totalTva;
  StatusModel? status;
  ClientModel? client;
  List<CommandDetailModel>? details;
  int? idClient;
  int? idSociete;
  int? isSent;
  int? isDone;

  CommandModel({
    this.id,
    this.dateCommand,
    this.dateLivraisonPrevu,
    this.dateCreation,
    this.totalHt,
    this.totalTTC,
    this.totalTva,
    this.status,
    this.details,
    this.idClient,
    this.idSociete,
    this.client,
    this.isSent,
    this.isDone
  });

  Map<String,dynamic> toLocalJson(){
    return {
      "id":id,
      "client_id":idClient,
      "date":dateCommand,
      "is_done":isDone,
      "is_sent":isSent,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "societe_id": idSociete,
      "date_prevue_livraison": dateLivraisonPrevu?.formattedDateEn,
      "date_commande": dateCommand?.formattedDateEn,
      "fk_soc": idClient,
      "products":details?.map((e) => e.product?.toJsonForCommand()).toList()
    };
  }

  factory CommandModel.fromMap(Map<String, dynamic> json) {
    return CommandModel(
      id: json['id'] as int,
      dateCommand: json["dateCommand"] == null
          ? null
          : DateTime.parse(json['dateCommand']),
      dateCreation: json['dateCreation'] == null
          ? null
          : DateTime.parse(json['dateCreation']),
      totalHt: json['totalHt'],
      totalTTC: json['totalTTc'],
      totalTva: json['totalTVA'],
      client: json['client']==null?null:ClientModel.fromJson(json['client']),
      status:
          json['status'] == null ? null : StatusModel.fromMap(json['status']),
      details: json['details'] == null
          ? null
          : (json['details'] as List)
              .map((e) => CommandDetailModel.fromJson(e))
              .toList(),
      idClient: json['client_id'],
      isDone: json['id_done'],
      isSent: json['is_sent']
    );
  }

  CommandEntity toEntity() {
    return CommandEntity(
        id: id,
        status: status?.toEntity(),
        dateCreation: dateCreation,
        dateCommand: dateCommand,
        totalHt: totalHt,
        totalTTC: totalTTC,
        totalTva: totalTva,
        client: client?.toEntity(),
        details: details?.map((e) => e.toEntity()).toList(),
        isSent: isSent,
      isDone: isDone,
      idClient:idClient,
    );
  }

  static CommandModel toModel(CommandEntity command) {
    return CommandModel(
        dateCommand: command.dateCommand,
        dateLivraisonPrevu: command.dateLivraisonPrevue,
        idClient: command.idClient,
        idSociete: command.idSociete,
        details: command.details
            ?.map((e) => CommandDetailModel.toModel(e))
            .toList());
  }
}
