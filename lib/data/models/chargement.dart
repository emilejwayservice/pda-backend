



import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/data/models/entrepot.dart';
import 'package:pda/data/models/product.dart';
import 'package:pda/domain/entities/chargement.dart';



class ChargementModel{
  int? id;
  bool? emitValider;
  String? code;
  EntrepotModel? entrepot;

  int? companyId;
  int? userId;
  int? entropotDetination;
  int? entropotSource;
  DateTime? dateCommand;
  List<ProductModel>? products;


  ChargementModel({
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

  factory ChargementModel.fromJson(Map<String, dynamic> json) {
    return ChargementModel(
      id: json['id'] ,
      emitValider: json['emitValider'] ,
      code: json['code'],
      entrepot: json['entrepot']==null?null:EntrepotModel.fromJson(json['entrepot']),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'societe_id': this.companyId,
      'user_id': this.userId,
      'fk_entrepot_d': this.entropotDetination,
      'fk_entrepot_src': this.entropotSource,
      'date_commande': this.dateCommand!.formattedDateEn,
      'products': this.products!.map((e) => e.toJsonForChargement()).toList(),
    };
  }


  static ChargementModel toModel(ChargementEntity chargement){
    return ChargementModel(
      companyId: chargement.companyId,
      userId: chargement.userId,
        entropotDetination: chargement.entropotDetination,
        entropotSource: chargement.entropotSource,
        dateCommand: chargement.dateCommand,
        products: chargement.products!.map((e) => ProductModel.toModel(e)).toList()
    );
  }

  ChargementEntity toEntity(){
    return ChargementEntity(
      id: id,
      entrepot: entrepot?.toEntity(),
      code: code,
      emitValider: emitValider
    );
  }





}