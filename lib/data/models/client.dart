import 'package:pda/data/models/command.dart';
import 'package:pda/data/models/facture.dart';
import 'package:pda/data/models/livraison.dart';
import 'package:pda/domain/entities/client.dart';



class ClientModel{
  int? id;
  String? address;
  String? codeClient;
  String? clientClass;
  String? activity;
  double? solde;
  String? nom;
  String? email;
  String? tel;
  String? city;
  bool? isProspect;
  List<LivraisonModel>? livraisons;
  List<FactureModel>? factures;
  List<CommandModel>? commands;


  int? fkCategoryPrice;
  String? numero;
  int? userId;

  int? typeClient;
  int? activityClient;



  ClientModel({
    this.id,
    this.address,
    this.codeClient,
    this.clientClass,
    this.activity,
    this.solde,
    this.fkCategoryPrice,
    this.numero,
    this.userId,
    this.livraisons,
    this.email,
    this.nom,
    this.city,
    this.tel,
    this.isProspect,
    this.factures,
    this.commands,
    this.activityClient,
    this.typeClient
  });


  Map<String, dynamic> toJson() {
    return {
      "name":nom,
      "email":email,
      "categoryClient":typeClient,
      "activityClient":activityClient,
      "address":address,
      "city":city,
      "phone":tel
    };
  }




  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      address: json['address'] ,
      codeClient: json['codeClient'] ,
      clientClass: json['clientClass'] ,
      activity: json['activity'] ,
      solde: json['solde'] ,
      email: json['email'],
      nom: json['nom'],
      numero: json['numero'],
      tel: json['tel'],
      city: json['city'],
      isProspect: json['prospect'],
      livraisons: json['livraisons']==null?null:(json['livraisons'] as List).map((e) => LivraisonModel.fromMap(e)).toList(),
      factures: json['factures']==null?null:(json['factures'] as List).map((e) => FactureModel.fromMap(e)).toList(),
      commands: json['commands']==null?null:(json['commands'] as List).map((e) => CommandModel.fromMap(e)).toList(),
    );
  }

  ClientEntity toEntity(){
    return ClientEntity(
      activity: activity,
      id: id,
      address: address,
      clientClass: clientClass,
      codeClient: codeClient,
      solde: solde,
      city: city,
      tel: tel,
      numero: numero,
      nom: nom,
      email: email,
      userId: userId,
      fkCategoryPrice: fkCategoryPrice,
      isProspect: isProspect,
      livraisons: livraisons?.map((e) => e.toEntity()).toList(),
      factures: factures?.map((e) => e.toEntity()).toList(),
      commands: commands?.map((e) => e.toEntity()).toList(),
    );
  }

  static ClientModel toModel(ClientEntity client){
    return ClientModel(
      id: client.id,
      nom: client.nom,
      email: client.email,
      tel: client.tel,
      city: client.city,
      activityClient: client.activityClient,
      address: client.address,
      typeClient: client.typeClient
    );
  }



}