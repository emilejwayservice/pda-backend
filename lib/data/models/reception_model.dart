import 'reception_entity.dart';

/// Maps ReceptionResponseDTO
class ReceptionModel {
  final int? rowid;
  final String? refInt;
  final String? refFournisseur;
  final String? bateau;
  final double? totalHt;
  final double? totalTtc;
  final double? totalTva;
  final String? destination;
  final double? fraisTotals;
  final String? dateReception;

  const ReceptionModel({
    this.rowid,
    this.refInt,
    this.refFournisseur,
    this.bateau,
    this.totalHt,
    this.totalTtc,
    this.totalTva,
    this.destination,
    this.fraisTotals,
    this.dateReception,
  });

  factory ReceptionModel.fromJson(Map<String, dynamic> json) {
    return ReceptionModel(
      rowid: json['rowid'],
      refInt: json['ref_int'],
      refFournisseur: json['ref_fournisseur'],
      bateau: json['bateau'],
      totalHt: (json['total_ht'] as num?)?.toDouble(),
      totalTtc: (json['total_ttc'] as num?)?.toDouble(),
      totalTva: (json['total_tva'] as num?)?.toDouble(),
      destination: json['destination']?.toString(),
      fraisTotals: (json['frais_totals'] as num?)?.toDouble(),
      dateReception: json['date_reception']?.toString(),
    );
  }

  ReceptionEntity toEntity() {
    DateTime? date;
    if (dateReception != null) {
      try {
        date = DateTime.parse(dateReception!);
      } catch (_) {}
    }
    return ReceptionEntity(
      id: rowid,
      refInt: refInt,
      refFournisseur: refFournisseur,
      bateau: bateau,
      totalHt: totalHt,
      totalTtc: totalTtc,
      totalTva: totalTva,
      destination: destination,
      fraisTotals: fraisTotals,
      dateReception: date,
    );
  }
}

/// Maps ReceptionDetailsResponseDTO — all fields present
class ReceptionDetailModel {
  final int? rowid;
  final int? fkReception;
  final int? fkProduct;
  final String? produit;
  final String? label;
  final String? description;
  final double? qty;
  final double? totalsKg;
  final double? qty2;
  final double? price;
  final double? totalTva;
  final double? totalHt;
  final double? totalTtc;
  final double? tva;
  final String? refFournisseur;
  final int? fkBda;
  final int? nbCaisses;
  final String? typeCaisses;
  final int? fkUnite;
  final int? fkBcDetail;
  final double? qtyRestante;
  final double? qtyFacture;
  final double? qtyRetour;
  final String? lot;
  final double? nbreCs;
  final double? puBrut;
  final double? puBrutExact;
  final double? poidsBrut;
  final String? bateau;
  final double? puNet;
  final double? poidsNet;
  final int? fkBoat;

  const ReceptionDetailModel({
    this.rowid,
    this.fkReception,
    this.fkProduct,
    this.produit,
    this.label,
    this.description,
    this.qty,
    this.totalsKg,
    this.qty2,
    this.price,
    this.totalTva,
    this.totalHt,
    this.totalTtc,
    this.tva,
    this.refFournisseur,
    this.fkBda,
    this.nbCaisses,
    this.typeCaisses,
    this.fkUnite,
    this.fkBcDetail,
    this.qtyRestante,
    this.qtyFacture,
    this.qtyRetour,
    this.lot,
    this.nbreCs,
    this.puBrut,
    this.puBrutExact,
    this.poidsBrut,
    this.bateau,
    this.puNet,
    this.poidsNet,
    this.fkBoat,
  });

  factory ReceptionDetailModel.fromJson(Map<String, dynamic> json) {
    return ReceptionDetailModel(
      rowid: json['rowid'],
      fkReception: json['fk_reception'],
      fkProduct: json['fk_product'],
      produit: json['produit'],
      label: json['label'],
      description: json['description'],
      qty: (json['qty'] as num?)?.toDouble(),
      totalsKg: (json['totals_kg'] as num?)?.toDouble(),
      qty2: (json['qty2'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      totalTva: (json['total_tva'] as num?)?.toDouble(),
      totalHt: (json['total_ht'] as num?)?.toDouble(),
      totalTtc: (json['total_ttc'] as num?)?.toDouble(),
      tva: (json['tva'] as num?)?.toDouble(),
      refFournisseur: json['ref_fournisseur'],
      fkBda: json['fk_bda'],
      nbCaisses: json['nb_caisses'],
      typeCaisses: json['type_caisses'],
      fkUnite: json['fk_unite'],
      fkBcDetail: json['fk_bc_detail'],
      qtyRestante: (json['qty_restante'] as num?)?.toDouble(),
      qtyFacture: (json['qty_facture'] as num?)?.toDouble(),
      qtyRetour: (json['qty_retour'] as num?)?.toDouble(),
      lot: json['lot']?.toString(),
      nbreCs: (json['nbre_cs'] as num?)?.toDouble(),
      puBrut: (json['pu_brut'] as num?)?.toDouble(),
      puBrutExact: (json['pu_brut_exact'] as num?)?.toDouble(),
      poidsBrut: (json['poids_brut'] as num?)?.toDouble(),
      bateau: json['bateau'],
      puNet: (json['pu_net'] as num?)?.toDouble(),
      poidsNet: (json['poids_net'] as num?)?.toDouble(),
      fkBoat: json['fk_boat'],
    );
  }

  ReceptionDetailEntity toEntity() {
    DateTime? lotDate;
    if (lot != null) {
      try {
        lotDate = DateTime.parse(lot!);
      } catch (_) {}
    }
    return ReceptionDetailEntity(
      id: rowid,
      fkReception: fkReception,
      fkProduct: fkProduct,
      produit: produit,
      label: label,
      description: description,
      qty: qty,
      totalsKg: totalsKg,
      qty2: qty2,
      price: price,
      totalTva: totalTva,
      totalHt: totalHt,
      totalTtc: totalTtc,
      tva: tva,
      refFournisseur: refFournisseur,
      fkBda: fkBda,
      nbCaisses: nbCaisses,
      typeCaisses: typeCaisses,
      fkUnite: fkUnite,
      fkBcDetail: fkBcDetail,
      qtyRestante: qtyRestante,
      qtyFacture: qtyFacture,
      qtyRetour: qtyRetour,
      lot: lotDate,
      nbreCs: nbreCs,
      puBrut: puBrut,
      puBrutExact: puBrutExact,
      poidsBrut: poidsBrut,
      bateau: bateau,
      puNet: puNet,
      poidsNet: poidsNet,
      fkBoat: fkBoat,
    );
  }
}

class FournisseurModel {
  final int? id;
  final String? nom;
  final String? codeFournisseur;
  const FournisseurModel({this.id, this.nom, this.codeFournisseur});
  factory FournisseurModel.fromJson(Map<String, dynamic> json) =>
      FournisseurModel(
          id: json['id'],
          nom: json['nom'],
          codeFournisseur: json['code_fournisseur']);
  FournisseurEntity toEntity() =>
      FournisseurEntity(id: id, nom: nom, codeFournisseur: codeFournisseur);
}

class EntrepotReceptionModel {
  final int? id;
  final String? libelle;
  const EntrepotReceptionModel({this.id, this.libelle});
  factory EntrepotReceptionModel.fromJson(Map<String, dynamic> json) =>
      EntrepotReceptionModel(id: json['id'], libelle: json['libelle']);
  EntrepotReceptionEntity toEntity() =>
      EntrepotReceptionEntity(id: id, libelle: libelle);
}

class ArticleModel {
  final int? id;
  final double? tva;
  final String? libelle;
  const ArticleModel({this.id, this.tva, this.libelle});
  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
      id: json['id'],
      tva: (json['tva'] as num?)?.toDouble(),
      libelle: json['libelle']);
  ArticleEntity toEntity() => ArticleEntity(id: id, tva: tva, libelle: libelle);
}

class BateauModel {
  final int? id;
  final String? nom;
  const BateauModel({this.id, this.nom});
  factory BateauModel.fromJson(Map<String, dynamic> json) =>
      BateauModel(id: json['id'], nom: json['nom']);
  BateauEntity toEntity() => BateauEntity(id: id, nom: nom);
}

class UniteModel {
  final int? rowid;
  final String? label;
  final String? code;
  const UniteModel({this.rowid, this.label, this.code});
  factory UniteModel.fromJson(Map<String, dynamic> json) => UniteModel(
      rowid: json['rowid'], label: json['label'], code: json['code']);
  UniteEntity toEntity() => UniteEntity(rowid: rowid, label: label, code: code);
}

class NextRefModel {
  final String? nextref;
  const NextRefModel({this.nextref});
  factory NextRefModel.fromJson(Map<String, dynamic> json) =>
      NextRefModel(nextref: json['nextref']);
}

/// GET /apiMobile/receptions/{id_article}/unit
class ArticleUnitModel {
  final double? tva;
  final String? label;
  final String? unite;
  final int? fkUnite;
  const ArticleUnitModel({this.tva, this.label, this.unite, this.fkUnite});
  factory ArticleUnitModel.fromJson(Map<String, dynamic> json) =>
      ArticleUnitModel(
        tva: (json['tva'] as num?)?.toDouble(),
        label: json['label'],
        unite: json['unite'],
        fkUnite: json['fkUnite'] as int?,
      );
}
