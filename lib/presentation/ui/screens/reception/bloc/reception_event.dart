part of 'reception_bloc.dart';

abstract class ReceptionEvent {}

class FetchReceptionList extends ReceptionEvent {}

class FetchReceptionData extends ReceptionEvent {}

/// Fetches /apiMobile/receptions/next-ref and populates state.nextRef
class FetchNextRef extends ReceptionEvent {}

/// Fetches /apiMobile/receptions/{id}/unit after article selected
class FetchArticleUnit extends ReceptionEvent {
  final int idArticle;
  FetchArticleUnit(this.idArticle);
}

class SelectReceptionDate extends ReceptionEvent {
  final DateTime date;
  SelectReceptionDate(this.date);
}

class SelectLotDate extends ReceptionEvent {
  final DateTime date;
  SelectLotDate(this.date);
}

class SelectFournisseur extends ReceptionEvent {
  final FournisseurEntity fournisseur;
  SelectFournisseur(this.fournisseur);
}

class SelectEntrepotReception extends ReceptionEvent {
  final EntrepotReceptionEntity entrepot;
  SelectEntrepotReception(this.entrepot);
}

class SelectArticle extends ReceptionEvent {
  final ArticleEntity article;
  SelectArticle(this.article);
}

class SelectBateau extends ReceptionEvent {
  final BateauEntity bateau;
  SelectBateau(this.bateau);
}

class SelectUnite extends ReceptionEvent {
  final UniteEntity unite;
  SelectUnite(this.unite);
}

class SubmitReception extends ReceptionEvent {
  final String? destination;
  final double? frais;
  SubmitReception({
    this.destination,
    this.frais,
  });
}

class SubmitReceptionDetail extends ReceptionEvent {
  final int nbrCaisse; // nbr_caisse: Integer
  final double
      puBrut; // pubrut unitaire (saisie), poids_brut = puBrut × nbrCaisse
  final double poidsBrut; // poisbrut: auto-calculated = puBrut × nbrCaisse
  final double? price; // prix unitaire (optionnel), drives totalHt/TTC
  final double tva; // from articleUnit (auto)
  SubmitReceptionDetail({
    required this.nbrCaisse,
    required this.puBrut,
    required this.poidsBrut,
    this.price,
    required this.tva,
  });
}

class ResetReception extends ReceptionEvent {}

class GoToStep extends ReceptionEvent {
  final int step;
  GoToStep(this.step);
}
