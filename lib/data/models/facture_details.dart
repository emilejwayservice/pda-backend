import 'package:pda/data/models/product.dart';
import 'package:pda/domain/entities/facture_details.dart';

class FactureDetailModel {
  int? id;
  int? quantity;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductModel? product;

  FactureDetailModel({
    this.id,
    this.quantity,
    this.price,
    this.totalHt,
    this.totalTva,
    this.totalTTC,
    this.product,
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

  factory FactureDetailModel.fromJson(Map<String, dynamic> json) {
    return FactureDetailModel(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'],
      totalHt: json['totalHt'],
      totalTva: json['totalTva'],
      totalTTC: json['totalTTc'],
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product']),
    );
  }
  FactureDetailEntity toEntity() {
    return FactureDetailEntity(
      totalTva: totalTva,
      totalTTC: totalTTC,
      totalHt: totalHt,
      id: id,
      quantity: quantity,
      price: price,
      product: product?.toEntity(),
    );
  }
}
