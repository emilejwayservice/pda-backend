part of 'reception_bloc.dart';

class ReceptionState {
  final AppStatus fetchDataStatus;
  final AppStatus fetchListStatus;
  final AppStatus fetchNextRefStatus;
  final AppStatus fetchArticleUnitStatus;
  final AppStatus submitReceptionStatus;
  final AppStatus submitDetailStatus;

  final List<ReceptionEntity> receptions;

  final List<FournisseurEntity> fournisseurs;
  final List<EntrepotReceptionEntity> entrepots;
  final List<ArticleEntity> articles;
  final List<BateauEntity> bateaux;
  final List<UniteEntity> unites;

  // Auto-filled from /next-ref — used as ref_fournisseur in form (disabled)
  final String? nextRef;

  // Auto-filled from /{id_article}/unit when article selected
  final ArticleUnitEntity? articleUnit;

  final FournisseurEntity? selectedFournisseur;
  final EntrepotReceptionEntity? selectedEntrepot;
  final ArticleEntity? selectedArticle;
  final BateauEntity? selectedBateau;
  final UniteEntity? selectedUnite;

  final DateTime selectedDateReception;
  final DateTime selectedLot;

  final int? createdReceptionId;
  final bool? isOffline;
  final String? error;
  final int currentStep;

  const ReceptionState({
    this.fetchDataStatus = AppStatus.initial,
    this.fetchListStatus = AppStatus.initial,
    this.fetchNextRefStatus = AppStatus.initial,
    this.fetchArticleUnitStatus = AppStatus.initial,
    this.submitReceptionStatus = AppStatus.initial,
    this.submitDetailStatus = AppStatus.initial,
    this.receptions = const [],
    this.fournisseurs = const [],
    this.entrepots = const [],
    this.articles = const [],
    this.bateaux = const [],
    this.unites = const [],
    this.nextRef,
    this.articleUnit,
    this.selectedFournisseur,
    this.selectedEntrepot,
    this.selectedArticle,
    this.selectedBateau,
    this.selectedUnite,
    required this.selectedDateReception,
    required this.selectedLot,
    this.createdReceptionId,
    this.isOffline,
    this.error,
    this.currentStep = 0,
  });

  ReceptionState copyWith({
    AppStatus? fetchDataStatus,
    AppStatus? fetchListStatus,
    AppStatus? fetchNextRefStatus,
    AppStatus? fetchArticleUnitStatus,
    AppStatus? submitReceptionStatus,
    AppStatus? submitDetailStatus,
    List<ReceptionEntity>? receptions,
    List<FournisseurEntity>? fournisseurs,
    List<EntrepotReceptionEntity>? entrepots,
    List<ArticleEntity>? articles,
    List<BateauEntity>? bateaux,
    List<UniteEntity>? unites,
    String? nextRef,
    ArticleUnitEntity? articleUnit,
    bool clearArticleUnit = false,
    FournisseurEntity? selectedFournisseur,
    EntrepotReceptionEntity? selectedEntrepot,
    ArticleEntity? selectedArticle,
    bool clearSelectedArticle = false,
    BateauEntity? selectedBateau,
    UniteEntity? selectedUnite,
    DateTime? selectedDateReception,
    DateTime? selectedLot,
    int? createdReceptionId,
    bool? isOffline,
    String? error,
    int? currentStep,
  }) {
    return ReceptionState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      fetchListStatus: fetchListStatus ?? this.fetchListStatus,
      fetchNextRefStatus: fetchNextRefStatus ?? this.fetchNextRefStatus,
      fetchArticleUnitStatus:
          fetchArticleUnitStatus ?? this.fetchArticleUnitStatus,
      submitReceptionStatus:
          submitReceptionStatus ?? this.submitReceptionStatus,
      submitDetailStatus: submitDetailStatus ?? this.submitDetailStatus,
      receptions: receptions ?? this.receptions,
      fournisseurs: fournisseurs ?? this.fournisseurs,
      entrepots: entrepots ?? this.entrepots,
      articles: articles ?? this.articles,
      bateaux: bateaux ?? this.bateaux,
      unites: unites ?? this.unites,
      nextRef: nextRef ?? this.nextRef,
      articleUnit: clearArticleUnit ? null : (articleUnit ?? this.articleUnit),
      selectedFournisseur: selectedFournisseur ?? this.selectedFournisseur,
      selectedEntrepot: selectedEntrepot ?? this.selectedEntrepot,
      selectedArticle: clearSelectedArticle
          ? null
          : (selectedArticle ?? this.selectedArticle),
      selectedBateau: selectedBateau ?? this.selectedBateau,
      selectedUnite: selectedUnite ?? this.selectedUnite,
      selectedDateReception:
          selectedDateReception ?? this.selectedDateReception,
      selectedLot: selectedLot ?? this.selectedLot,
      createdReceptionId: createdReceptionId ?? this.createdReceptionId,
      isOffline: isOffline,
      error: error,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
