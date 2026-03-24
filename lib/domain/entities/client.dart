import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/entities/facture.dart';



class ClientEntity{
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
  List<LivraisonEntity>? livraisons;
  List<FactureEntity>? factures;
  List<CommandEntity>? commands;


  int? fkCategoryPrice;
  String? numero;
  int? userId;


  int? typeClient;
  int? activityClient;



  ClientEntity({
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
    this.typeClient,
    this.activityClient
  });

  ClientEntity copyWith({
    int? id,
    String? address,
    String? codeClient,
    String? clientClass,
    String? activity,
    double? solde,
    String? nom,
    String? email,
    String? tel,
    String? city,
    bool? isProspect,
    List<LivraisonEntity>? livraisons,
    List<FactureEntity>? factures,
    List<CommandEntity>? commands,
    int? fkCategoryPrice,
    String? numero,
    int? userId,
    int? typeClient,
    int? activityClient,
  }) {
    return ClientEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      codeClient: codeClient ?? this.codeClient,
      clientClass: clientClass ?? this.clientClass,
      activity: activity ?? this.activity,
      solde: solde ?? this.solde,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      tel: tel ?? this.tel,
      city: city ?? this.city,
      isProspect: isProspect ?? this.isProspect,
      livraisons: livraisons ?? this.livraisons,
      factures: factures ?? this.factures,
      commands: commands ?? this.commands,
      fkCategoryPrice: fkCategoryPrice ?? this.fkCategoryPrice,
      numero: numero ?? this.numero,
      userId: userId ?? this.userId,
      typeClient: typeClient ?? this.typeClient,
      activityClient: activityClient ?? this.activityClient,
    );
  }
}