

import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/data/models/product.dart';
import 'package:pda/data/models/status.dart';
import 'package:pda/domain/entities/retour.dart';

import 'client.dart';
import 'entrepot.dart';



class RetourModel{
   int? id;
   DateTime? dateCreation;
   DateTime? dateRetour;
   ClientModel? client;
   StatusModel? status;
   int? company;
   int? entrepot;
   List<Map<String,dynamic>>? products;
   List<ProductModel>? productsM;
   EntrepotModel? entrepotM;
   int? livraisonId;

   RetourModel({
    this.id,
    this.dateCreation,
    this.dateRetour,
     this.client,
     this.status,
     this.company,
     this.products,
     this.entrepot,
     this.entrepotM,
     this.productsM,
     this.livraisonId
  });



  factory RetourModel.fromJson(Map<String, dynamic> json) {
    return RetourModel(
      id: json['id'] ,
      dateCreation: json['dateCreation']==null?null:DateTime.parse(json['dateCreation']) ,
      dateRetour: json['dateRetour']==null?null:DateTime.parse(json['dateRetour']),
      client: json['client']==null?null:ClientModel.fromJson(json['client']),
      status: json['status']==null?null:StatusModel.fromMap(json['status']),
      entrepotM: json['entrepot']==null?null:EntrepotModel.fromJson(json['entrepot']),
      productsM: json['products']==null?null:(json['products'] as List).map((e) => ProductModel.fromJson(e)).toList(),

    );
  }




  RetourEntity toEntity(){
    return RetourEntity(
      status: status?.toEntity(),
      id: id,
      client: client?.toEntity(),
      dateCreation: dateCreation,
      dateRetour: dateRetour,
      entrepotE: entrepotM?.toEntity(),
      productsE: productsM?.map((e) => e.toEntity()).toList()
    );
  }

  static RetourModel toModel(RetourEntity retour){
    return RetourModel(
      dateRetour: retour.dateRetour,
      company: retour.company,
      products: retour.products,
      entrepot: retour.entrepot,
      client: ClientModel.toModel(retour.client!),
      livraisonId: retour.livraisonId
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "dateRetour":dateRetour?.formattedDateEn,
      "company":company,
      "entrepot":entrepot,
      "client":client?.id,
      "products":products,
      "livraison":livraisonId
    };
  }



}