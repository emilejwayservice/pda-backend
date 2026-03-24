


import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/domain/entities/status.dart';

import 'entrepot.dart';

class RetourEntity{
  int? id;
  DateTime? dateCreation;
  DateTime? dateRetour;
  ClientEntity? client;
  StatusEntity? status;
  int? company;
  int? entrepot;
  List<Map<String,dynamic>>? products;
  List<ProductEntity>? productsE;
  EntrepotEntity? entrepotE;
  int? livraisonId;


  RetourEntity({
    this.id,
    this.dateCreation,
    this.dateRetour,
    this.client,
    this.status,
    this.entrepot,
    this.company,
    this.products,
    this.productsE,
    this.entrepotE,
    this.livraisonId
  });



}