class ReceptionEntity {
  int? id;
  String? refInt;
  String? refFournisseur;
  String? bateau;
  double? totalHt;
  double? totalTtc;
  double? totalTva;
  String? destination;
  double? fraisTotals;
  DateTime? dateReception;

  ReceptionEntity({
    this.id,
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

  ReceptionEntity copyWith({
    int? id,
    String? refInt,
    String? refFournisseur,
    String? bateau,
    double? totalHt,
    double? totalTtc,
    double? totalTva,
    String? destination,
    double? fraisTotals,
    DateTime? dateReception,
  }) {
    return ReceptionEntity(
      id: id ?? this.id,
      refInt: refInt ?? this.refInt,
      refFournisseur: refFournisseur ?? this.refFournisseur,
      bateau: bateau ?? this.bateau,
      totalHt: totalHt ?? this.totalHt,
      totalTtc: totalTtc ?? this.totalTtc,
      totalTva: totalTva ?? this.totalTva,
      destination: destination ?? this.destination,
      fraisTotals: fraisTotals ?? this.fraisTotals,
      dateReception: dateReception ?? this.dateReception,
    );
  }

  String get displayRef => refInt ?? refFournisseur ?? '#$id';
}

/// Maps to ReceptionDetailsResponseDTO
class ReceptionDetailEntity {
  int? id;
  int? fkReception;
  int? fkProduct;
  String? produit;
  String? label;
  String? description;
  double? qty;
  double? totalsKg;
  double? qty2;
  double? price;
  double? totalTva;
  double? totalHt;
  double? totalTtc;
  double? tva;
  String? refFournisseur;
  int? fkBda;
  int? nbCaisses;
  String? typeCaisses;
  int? fkUnite;
  int? fkBcDetail;
  double? qtyRestante;
  double? qtyFacture;
  double? qtyRetour;
  DateTime? lot;
  double? nbreCs;
  double? puBrut;
  double? puBrutExact;
  double? poidsBrut;
  String? bateau;
  double? puNet;
  double? poidsNet;
  int? fkBoat;

  ReceptionDetailEntity({
    this.id,
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
}

/// Maps to fournisseurs lookup
class FournisseurEntity {
  int? id;
  String? nom;
  String? codeFournisseur;
  FournisseurEntity({this.id, this.nom, this.codeFournisseur});
}

/// Maps to entrepots lookup
class EntrepotReceptionEntity {
  int? id;
  String? libelle;
  EntrepotReceptionEntity({this.id, this.libelle});
}

/// Maps to articles lookup
class ArticleEntity {
  int? id;
  double? tva;
  String? libelle;
  ArticleEntity({this.id, this.tva, this.libelle});
}

/// Maps to bateaux lookup
class BateauEntity {
  int? id;
  String? nom;
  BateauEntity({this.id, this.nom});
}

/// Maps to unites lookup
class UniteEntity {
  int? rowid;
  String? label;
  String? code;
  UniteEntity({this.rowid, this.label, this.code});
}

/// Used to build the ReceptionDetailsRequestDTO body
class ReceptionDetailRequest {
  final int fkProduct;
  final int nbrCaisse;
  final double puBrut;
  final double poidsBrut;
  final int bateau;
  final double price;
  final double totalHt;
  final double totalTtc;
  final int unite;
  final double tva;
  final String lot;

  const ReceptionDetailRequest({
    required this.fkProduct,
    required this.nbrCaisse,
    required this.puBrut,
    required this.poidsBrut,
    required this.bateau,
    required this.price,
    required this.totalHt,
    required this.totalTtc,
    required this.unite,
    required this.tva,
    required this.lot,
  });

  Map<String, dynamic> toJson() => {
        'fk_product': fkProduct,
        'nbr_caisse': nbrCaisse,
        'pubrut': puBrut,
        'poisbrut': poidsBrut,
        'bateau': bateau,
        'price': price,
        'total_HTT': totalHt,
        'total_ttc': totalTtc,
        'unite': unite,
        'tva': tva,
        'lot': lot,
      };
}

/// Used to build the ReceptionRequestDTO body
class ReceptionRequest {
  final String refFournisseur;
  final int fkSoc;
  final String dateReception;
  final int fkEntrepot;
  final String destination;
  final double frais;

  const ReceptionRequest({
    required this.refFournisseur,
    required this.fkSoc,
    required this.dateReception,
    required this.fkEntrepot,
    required this.destination,
    required this.frais,
  });

  Map<String, dynamic> toJson() => {
        'ref_fournisseur': refFournisseur,
        'fk_soc': fkSoc,
        'date_reception': dateReception,
        'fk_entrepot': fkEntrepot,
        'destination': destination,
        'frais': frais,
      };
}

/// Result of GET /apiMobile/receptions/{id_article}/unit
class ArticleUnitEntity {
  final double? tva;
  final String? label;
  final String? unite; // abbreviation — display only
  final int? fkUnite; // ID to save in reception detail (fk_unite)
  const ArticleUnitEntity({this.tva, this.label, this.unite, this.fkUnite});
}
