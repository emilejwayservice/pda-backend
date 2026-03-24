import 'package:pda/domain/entities/product.dart';

class LivraisonDetailEntity {
  int? id;
  int? quantity;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductEntity? product;

  LivraisonDetailEntity({
    this.id,
    this.quantity,
    this.price,
    this.totalHt,
    this.totalTva,
    this.totalTTC,
    this.product,
  });
}