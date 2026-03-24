
import 'package:pda/data/models/product.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/facture_details.dart';

class CommandDetailModel{
  int? id;
  int? quantity;
  int? qtyRestante;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductModel? product;

  CommandDetailModel({
    this.id,
    this.quantity,
    this.price,
    this.totalHt,
    this.totalTva,
    this.totalTTC,
    this.product,
    this.qtyRestante
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'quantity': this.quantity,
      'price': this.price,
      'totalHt': this.totalHt,
      'totalTva': this.totalTva,
      'totalTTC': this.totalTTC,
      'product': this.product,
    };
  }

  factory CommandDetailModel.fromJson(Map<String, dynamic> json) {
    return CommandDetailModel(
      id: json['id'] ,
      quantity: json['qty'] ,
      qtyRestante: json['qtyRestante'],
      price: json['price'] ,
      totalHt: json['totalHt'] ,
      totalTva: json['totalTVA'],
      totalTTC: json['totalTTC'] ,
      product: json['product'] ==null?null:ProductModel.fromJson(json['product']),
    );
  }
  CommandDetailEntity toEntity(){
    return CommandDetailEntity(
      totalTva: totalTva,
      totalTTC: totalTTC,
      totalHt: totalHt,
      id: id,
      quantity: quantity,
      qtyRestante: qtyRestante,
      price: price,
      product: product?.toEntity(),
    );
  }
  static CommandDetailModel toModel(CommandDetailEntity command){
    return CommandDetailModel(
      product: ProductModel.toModel(command.product!)
    );
  }
}


