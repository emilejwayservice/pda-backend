import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/data/models/reception_entity.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

part 'reception_event.dart';
part 'reception_state.dart';

class ReceptionBloc extends Bloc<ReceptionEvent, ReceptionState> {
  ReceptionBloc()
      : super(ReceptionState(
          selectedDateReception: DateTime.now(),
          selectedLot: DateTime.now(),
        )) {
    on<FetchReceptionList>(_fetchList);
    on<FetchReceptionData>(_fetchData);
    on<FetchNextRef>(_fetchNextRef);
    on<FetchArticleUnit>(_fetchArticleUnit);
    on<SelectReceptionDate>(_selectDate);
    on<SelectLotDate>(_selectLot);
    on<SelectFournisseur>(_selectFournisseur);
    on<SelectEntrepotReception>(_selectEntrepot);
    on<SelectArticle>(_selectArticle);
    on<SelectBateau>(_selectBateau);
    on<SelectUnite>(_selectUnite);
    on<SubmitReception>(_submitReception);
    on<SubmitReceptionDetail>(_submitDetail);
    on<ResetReception>(_reset);
    on<GoToStep>(_goToStep);
  }

  // ─── List ───────────────────────────────────────────────────────────────────

  FutureOr<void> _fetchList(
      FetchReceptionList event, Emitter<ReceptionState> emit) async {
    try {
      emit(state.copyWith(fetchListStatus: AppStatus.loading));
      final repo = Dependencies.get<Repository>();
      final receptions = await repo.getReceptions();
      emit(state.copyWith(
          fetchListStatus: AppStatus.success, receptions: receptions));
    } on NetworkConnectivityException {
      emit(state.copyWith(fetchListStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(fetchListStatus: AppStatus.error));
    }
  }

  // ─── Form data (entrepots, articles, bateaux, unites) ───────────────────────

  FutureOr<void> _fetchData(
      FetchReceptionData event, Emitter<ReceptionState> emit) async {
    try {
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      final repo = Dependencies.get<Repository>();
      final company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      final results = await Future.wait([
        repo.getFournisseurs(),
        repo.getEntrepots(company),
        repo.getArticles(company),
        repo.getBateaux(),
        repo.getUnites(),
      ]);
      emit(state.copyWith(
        fetchDataStatus: AppStatus.success,
        fournisseurs: results[0] as List<FournisseurEntity>,
        entrepots: results[1] as List<EntrepotReceptionEntity>,
        articles: results[2] as List<ArticleEntity>,
        bateaux: results[3] as List<BateauEntity>,
        unites: results[4] as List<UniteEntity>,
      ));
    } on NetworkConnectivityException {
      emit(state.copyWith(fetchDataStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  // ─── Next ref ────────────────────────────────────────────────────────────────

  FutureOr<void> _fetchNextRef(
      FetchNextRef event, Emitter<ReceptionState> emit) async {
    try {
      emit(state.copyWith(fetchNextRefStatus: AppStatus.loading));
      final repo = Dependencies.get<Repository>();
      final ref = await repo.getNextRef();
      emit(state.copyWith(fetchNextRefStatus: AppStatus.success, nextRef: ref));
    } on NetworkConnectivityException {
      emit(
          state.copyWith(fetchNextRefStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(fetchNextRefStatus: AppStatus.error));
    }
  }

  // ─── Article unit (tva + unite) ──────────────────────────────────────────────

  FutureOr<void> _fetchArticleUnit(
      FetchArticleUnit event, Emitter<ReceptionState> emit) async {
    try {
      emit(state.copyWith(
        fetchArticleUnitStatus: AppStatus.loading,
        clearArticleUnit: true,
      ));
      final repo = Dependencies.get<Repository>();
      final unit = await repo.getArticleUnit(event.idArticle);
      emit(state.copyWith(
        fetchArticleUnitStatus: AppStatus.success,
        articleUnit: unit,
      ));
    } on NetworkConnectivityException {
      emit(state.copyWith(
          fetchArticleUnitStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(fetchArticleUnitStatus: AppStatus.error));
    }
  }

  // ─── Selections ──────────────────────────────────────────────────────────────

  FutureOr<void> _selectDate(
      SelectReceptionDate event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(selectedDateReception: event.date));
  }

  FutureOr<void> _selectLot(SelectLotDate event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(selectedLot: event.date));
  }

  FutureOr<void> _selectFournisseur(
      SelectFournisseur event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(selectedFournisseur: event.fournisseur));
  }

  FutureOr<void> _selectEntrepot(
      SelectEntrepotReception event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(selectedEntrepot: event.entrepot));
  }

  /// When article changes: update selectedArticle and trigger unit fetch
  FutureOr<void> _selectArticle(
      SelectArticle event, Emitter<ReceptionState> emit) {
    emit(
        state.copyWith(selectedArticle: event.article, clearArticleUnit: true));
    if (event.article.id != null) {
      add(FetchArticleUnit(event.article.id!));
    }
  }

  FutureOr<void> _selectBateau(
      SelectBateau event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(selectedBateau: event.bateau));
  }

  FutureOr<void> _selectUnite(SelectUnite event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(selectedUnite: event.unite));
  }

  // ─── Submit reception ────────────────────────────────────────────────────────

  FutureOr<void> _submitReception(
      SubmitReception event, Emitter<ReceptionState> emit) async {
    try {
      if (state.selectedEntrepot == null) {
        emit(state.copyWith(
            submitReceptionStatus: AppStatus.warning,
            error: "Veuillez sélectionner un entrepôt."));
        return;
      }
      if (state.nextRef == null || state.nextRef!.isEmpty) {
        emit(state.copyWith(
            submitReceptionStatus: AppStatus.warning,
            error: "La référence n'est pas encore chargée."));
        return;
      }
      emit(state.copyWith(submitReceptionStatus: AppStatus.loading));
      final repo = Dependencies.get<Repository>();
      final company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);

      final reception = await repo.createReception(
        ReceptionRequest(
          refFournisseur: state.nextRef!,
          fkSoc: company,
          dateReception: _formatDate(state.selectedDateReception),
          fkEntrepot: state.selectedEntrepot!.id!,
          destination: event.destination ?? '',
          frais: event.frais ?? 0.0,
        ),
      );
      emit(state.copyWith(
        submitReceptionStatus: AppStatus.success,
        createdReceptionId: reception.id,
        currentStep: 1,
      ));
    } on NetworkConnectivityException {
      emit(state.copyWith(
          submitReceptionStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(submitReceptionStatus: AppStatus.error));
    }
  }

  // ─── Submit detail ───────────────────────────────────────────────────────────

  FutureOr<void> _submitDetail(
      SubmitReceptionDetail event, Emitter<ReceptionState> emit) async {
    try {
      if (state.createdReceptionId == null) {
        emit(state.copyWith(
            submitDetailStatus: AppStatus.warning,
            error: "Aucune réception créée."));
        return;
      }
      if (state.selectedArticle == null) {
        emit(state.copyWith(
            submitDetailStatus: AppStatus.warning,
            error: "Veuillez sélectionner un article."));
        return;
      }
      if (state.selectedBateau == null) {
        emit(state.copyWith(
            submitDetailStatus: AppStatus.warning,
            error: "Veuillez sélectionner un bateau."));
        return;
      }
      if (state.articleUnit == null) {
        emit(state.copyWith(
            submitDetailStatus: AppStatus.warning,
            error: "Unité de l'article non chargée."));
        return;
      }

      // Correct formulas:
      // poids_brut = pu_brut (unitaire) × nbrCaisse  ← already pre-calculated in form
      // total_ht   = nbrCaisse × prix_unitaire
      // total_ttc  = nbrCaisse × prix_unitaire × (1 + tva/100)
      final double tva =
          event.tva > 0 ? event.tva : (state.articleUnit?.tva ?? 0.0);
      final double price = event.price ?? 0.0;
      final double totalHt = event.nbrCaisse * price;
      final double totalTtc = event.nbrCaisse * price * (1 + tva / 100);

      emit(state.copyWith(submitDetailStatus: AppStatus.loading));
      final repo = Dependencies.get<Repository>();

      await repo.createReceptionDetail(
        state.createdReceptionId!,
        ReceptionDetailRequest(
          fkProduct: state.selectedArticle!.id!,
          nbrCaisse: event.nbrCaisse,
          puBrut: event.puBrut, // unitaire
          poidsBrut:
              event.poidsBrut, // = puBrut × nbrCaisse (pre-calculated in form)
          bateau: state.selectedBateau!.id!,
          price: event.price ?? 0.0,
          totalHt: totalHt,
          totalTtc: totalTtc,
          unite: state.articleUnit?.fkUnite ?? state.selectedUnite?.rowid ?? 0,
          tva: tva,
          lot: _formatDate(state.selectedLot),
        ),
      );
      // Clear article selection after successful add
      emit(state.copyWith(
        submitDetailStatus: AppStatus.success,
        clearSelectedArticle: true,
        clearArticleUnit: true,
        fetchArticleUnitStatus: AppStatus.initial,
      ));
    } on NetworkConnectivityException {
      emit(
          state.copyWith(submitDetailStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(submitDetailStatus: AppStatus.error));
    }
  }

  // ─── Reset ───────────────────────────────────────────────────────────────────

  FutureOr<void> _reset(ResetReception event, Emitter<ReceptionState> emit) {
    emit(ReceptionState(
      fetchListStatus: state.fetchListStatus,
      receptions: state.receptions,
      fetchDataStatus: AppStatus.success,
      fournisseurs: state.fournisseurs,
      entrepots: state.entrepots,
      articles: state.articles,
      bateaux: state.bateaux,
      unites: state.unites,
      selectedDateReception: DateTime.now(),
      selectedLot: DateTime.now(),
    ));
  }

  FutureOr<void> _goToStep(GoToStep event, Emitter<ReceptionState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
