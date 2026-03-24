import 'package:pda/domain/entities/product.dart';




class ProductModel{
  int?id;
  String?labelle;
  String?code;
  String?marque;
  String?unitCode;
  int?unit;
  double?mesure;
  double?stock;
  double?pmp;
  int? quantity=0;
  int? is_sent;
  String? codeBar;
  double? price;
  double? priceByCategory;
  int? tva;
  double? reel;
  double? theorique;
  String? image_url;
  String? image_path;

  ProductModel({
    this.id,
    this.labelle,
    this.code,
    this.marque,
    this.unit,
    this.mesure,
    this.stock,
    this.pmp,
    this.quantity=0,
    this.codeBar,
    this.unitCode,
    this.price,
    this.priceByCategory,
    this.tva,
    this.reel,
    this.theorique,
    this.image_url,
    this.image_path,
    this.is_sent
  });

  Map<String, dynamic> toJsonForChargement() {
    return {
      'id': this.id,
      'qte': this.quantity,
    };
  }

  Map<String,dynamic> toLocalJson(){
    return {
      //"id":this.id,
      "name":this.labelle,
      "price":this.price,
      "quantity":this.quantity,
      "is_sent":0,
      "image_path":this.image_path,
      "image_url":this.image_url
    };
  }

  Map<String, dynamic> toJsonForCommand() {
    return {
      "id":id,
      "tva":tva,
      "qte":quantity,
      "price":price
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ,
      labelle: json['libelle'] ?? json['name']  ,
      code: json['code'] ,
      marque: json['marque']  ,
      unit: json['unit']  ,
      mesure: json['mesure']  ,
      stock: json['stock']  ,
      pmp: json['pmp'] ,
      codeBar: json['codeBar'],
      unitCode: json['unitCode'],
      price: json['price'] is int? double.parse(json['price'].toString()):json['price'] ,
      quantity: json['quantity'] !=null
          ?(double.parse(json['quantity'].toString()) ).toInt()
          :0,
      priceByCategory: json['priceByCategory'],
      reel: json['reel'],
      theorique: json['theorique'],
      image_path: json['image_path'],
      image_url: json['image_url'],
    );
  }


  ProductEntity toEntity(){
    return ProductEntity(
      id: id,
      code: code,
      labelle: labelle,
      marque: marque,
      mesure: mesure,
      pmp: pmp,
      stock: stock,
      unit: unit,
      codeBar: codeBar,
      unitCode: unitCode,
      priceByCategory: priceByCategory,
      price: price,
      quantity: quantity,
      reel: reel,
      theorique: theorique,
      image_path: image_path,
      image_url: image_url
    );
  }
  static ProductModel toModel(ProductEntity productEntity){
    return ProductModel(
      id: productEntity.id,
      quantity: productEntity.quantity,
      price: productEntity.prix,
      tva: productEntity.tva,
      labelle: productEntity.labelle,
      image_url: productEntity.image_url,
      image_path: productEntity.image_path
    );
  }



}