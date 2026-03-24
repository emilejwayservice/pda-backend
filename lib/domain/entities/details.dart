import 'package:pda/domain/entities/product.dart';

class LivraisonDetailEntity {
  int? id;
  double? quantity;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductEntity? product;
  double? tva;

  LivraisonDetailEntity({
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
      "id": product?.id,
      "tva": tva ?? 0.0, // valeur par défaut si null
      "price": price ?? 0.0,
      "qte": quantity ?? 0.0,
    };
  }
}
