
import 'package:pda/data/models/product.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/facture_details.dart';
import 'package:pda/domain/entities/product.dart';

class CommandDetailEntity{
  int? id;
  int? quantity;
  int? qtyRestante;
  int? qtyLivraison;
  double? price;
  double? totalHt;
  double? totalTva;
  double? totalTTC;
  ProductEntity? product;

  CommandDetailEntity({
    this.id,
    this.quantity,
    this.qtyRestante,
    this.price,
    this.totalHt,
    this.totalTva,
    this.totalTTC,
    this.product,
  });
}


