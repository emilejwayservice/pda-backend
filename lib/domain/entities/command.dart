
import 'package:pda/data/models/command_details.dart';
import 'package:pda/data/models/facture_details.dart';
import 'package:pda/data/models/status.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/domain/entities/facture.dart';
import 'package:pda/domain/entities/status.dart';




class CommandEntity{
  int? id;
  DateTime? dateCommand;
  DateTime? dateLivraisonPrevue;
  DateTime? dateCreation;
  double? totalHt;
  double? totalTTC;
  double? totalTva;
  StatusEntity? status;
  ClientEntity? client;
  List<CommandDetailEntity>? details;
  int? idSociete;
  int? idClient;
  int? isSent;
  int? isDone;


  CommandEntity({
    this.id,
    this.dateCommand,
    this.dateLivraisonPrevue,
    this.dateCreation,
    this.totalHt,
    this.totalTTC,
    this.totalTva,
    this.status,
    this.details,
    this.idSociete,
    this.idClient,
    this.client,
    this.isSent,
    this.isDone
  });
}

