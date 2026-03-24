

import 'package:pda/domain/entities/entrepot.dart';
import 'package:pda/domain/entities/product.dart';

class ChargementEntity {
  int? id;
  bool? emitValider;
  String? code;
  EntrepotEntity? entrepot;

  int? companyId;
  int? userId;
  int? entropotDetination;
  int? entropotSource;
  DateTime? dateCommand;
  List<ProductEntity>? products;

  ChargementEntity({
    this.id,
    this.emitValider,
    this.code,
    this.entrepot,
    this.companyId,
    this.userId,
    this.entropotDetination,
    this.entropotSource,
    this.dateCommand,
    this.products,
  });
}