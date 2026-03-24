
import 'package:pda/data/models/product.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/product.dart';

class FactureDetailEntity{
  int? id;
  int? quantity;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductEntity? product;

  FactureDetailEntity({
    this.id,
    this.quantity,
    this.price,
    this.totalHt,
    this.totalTva,
    this.totalTTC,
    this.product,
  });


}


