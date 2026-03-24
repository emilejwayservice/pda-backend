import 'package:pda/data/models/product.dart';
import 'package:pda/domain/entities/details.dart';

class LivraisonDetailModel {
  int? id;
  double? quantity;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductModel? product;
  double? tva;

  LivraisonDetailModel({
    this.id,
    this.quantity,
    this.price,
    this.totalHt,
    this.totalTva,
    this.totalTTC,
    this.product,
    this.tva,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': product?.id,
      'qte': quantity,
      'price': price,
      'tva': tva,
    };
  }

  static LivraisonDetailModel toModel(LivraisonDetailEntity liv) {
    return LivraisonDetailModel(
      product: ProductModel.toModel(liv.product!),
      quantity: liv.quantity,
      price: liv.price,
      tva: liv.tva,
    );
  }

  factory LivraisonDetailModel.fromMap(Map<String, dynamic> json) {
    return LivraisonDetailModel(
      id: json['id'],
      quantity: json['quantity'] != null
          ? double.tryParse(json['quantity'].toString())
          : null,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      totalHt: json['totalHt'] != null
          ? double.tryParse(json['totalHt'].toString())
          : null,
      totalTva: json['totalTva'] != null
          ? double.tryParse(json['totalTva'].toString())
          : null,
      totalTTC: json['totalTTc'] != null
          ? double.tryParse(json['totalTTc'].toString())
          : null,
      tva: json['tva'] != null ? double.tryParse(json['tva'].toString()) : null,
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product']),
    );
  }

  LivraisonDetailEntity toEntity() {
    return LivraisonDetailEntity(
      totalTva: totalTva,
      totalTTC: totalTTC,
      totalHt: totalHt,
      id: id,
      quantity: quantity,
      price: price,
      tva: tva,
      product: product?.toEntity(),
    );
  }
}
