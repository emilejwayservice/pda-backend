import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/domain/entities/retour.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/entities/entrepot.dart';

part 'add_retour_event.dart';
part 'add_retour_state.dart';

class AddRetourBloc extends Bloc<AddRetourEvent, AddRetourState> {
  AddRetourBloc() : super(AddRetourState(selectedDateRetour: DateTime.now())) {
    on<FetchData>(_fetchData);
    on<SelectDate>(_selectDate);
    on<SelectClient>(_selectClient);
    on<SelectEntrepot>(_selectEntrepot);
    on<SelectLivraison>(_selectLivraison);
    on<Valider>(_valider);
    on<ResetForm>(_resetForm);
  }
  FutureOr<void> _resetForm(
      ResetForm event, Emitter<AddRetourState> emit) async {
    // Keep clients & entrepots, reset everything else
    emit(AddRetourState(
      fetchDataStatus: AppStatus.success,
      clients: state.clients,
      entrepots: state.entrepots,
      selectedDateRetour: DateTime.now(),
    ));
  }

  FutureOr<void> _fetchData(
      FetchData event, Emitter<AddRetourState> emit) async {
    try {
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      Repository repository = Dependencies.get<Repository>();
      int company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      var result = await Future.wait([
        repository.getClients(company),
        repository.getListEntropot(society: company, idType: 3),
      ]);
      List<ClientEntity> clients = result[0] as List<ClientEntity>;
      List<EntrepotEntity> entrepots = result[1] as List<EntrepotEntity>;
      emit(state.copyWith(
          fetchDataStatus: AppStatus.success,
          clients: clients,
          entrepots: entrepots));
    } on NetworkConnectivityException catch (ex) {
      emit(state.copyWith(fetchDataStatus: AppStatus.error, isOffline: true));
    } catch (ex) {
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  FutureOr<void> _selectDate(SelectDate event, Emitter<AddRetourState> emit) {
    emit(state.copyWith(selectedDateRetour: event.date));
  }

  FutureOr<void> _selectEntrepot(
      SelectEntrepot event, Emitter<AddRetourState> emit) {
    emit(state.copyWith(selectedEntrepot: event.entrepot));
  }

  FutureOr<void> _selectClient(
      SelectClient event, Emitter<AddRetourState> emit) async {
    try {
      emit(state.copyWith(
          fetchProductsStatus: AppStatus.loading,
          selectedClient: event.client));
      Repository repository = Dependencies.get<Repository>();
      int company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      List<LivraisonEntity> livraisons =
          await repository.getLivraisonsByClient(event.client.id!, company);

      // Deduplication ici
      final uniqueLivraisons =
          {for (var l in livraisons) l.id: l}.values.toList();

      emit(state.copyWith(
        fetchProductsStatus: AppStatus.success,
        livraisons: uniqueLivraisons,
        selectedLivraison: null, // reset la sélection précédente
      ));
    } on NetworkConnectivityException catch (ex) {
      emit(state.copyWith(
          fetchProductsStatus: AppStatus.error, isOffline: true));
    } catch (ex) {
      emit(state.copyWith(fetchProductsStatus: AppStatus.error));
    }
  }

  FutureOr<void> _valider(Valider event, Emitter<AddRetourState> emit) async {
    try {
      List<ProductEntity> selectedProducts =
          (state.selectedLivraison?.details ?? [])
              .where((element) => element.product!.isSelected)
              .map((e) => e.product!)
              .toList();
      if (selectedProducts.isEmpty) {
        emit(state.copyWith(
            validerStatus: AppStatus.warning,
            error: "Vous devez sélectionner des produits."));
        return;
      }
      List<ProductEntity> invalidProducts = selectedProducts
          .where((element) => (element.isSelected &&
              (element.quantity == null || element.quantity == 0)))
          .toList();
      if (invalidProducts.isNotEmpty) {
        emit(state.copyWith(
            validerStatus: AppStatus.warning,
            error: "Vous devez saisir la quantité de chaque produit."));
        return;
      }
      if (state.selectedEntrepot == null) {
        emit(state.copyWith(
            validerStatus: AppStatus.warning,
            error: "Vous devez sélectionner un entrepôt."));
        return;
      }
      /*if(state.selectedClient==null){
        emit(state.copyWith(validerStatus: AppStatus.warning,error: "Vous devez sélectionner un client."));
        return;
      }*/

      emit(state.copyWith(validerStatus: AppStatus.loading));
      List<Map<String, dynamic>> prodData = [];
      for (ProductEntity prod in selectedProducts) {
        prodData
            .add({"id": prod.id, "qte": prod.quantity, "cause": event.cause});
      }
      int company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      RetourEntity retour = RetourEntity(
          dateRetour: state.selectedDateRetour,
          products: prodData,
          entrepot: state.selectedEntrepot!.id,
          company: company,
          client: state.selectedClient,
          livraisonId: state.selectedLivraison?.id);
      Repository repository = Dependencies.get<Repository>();
      await repository.addRetour(retour);
      CoreBloc coreBloc = Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateRetours());
      clearProductsQuantity();
      emit(state.copyWith(validerStatus: AppStatus.success));
    } on NetworkConnectivityException catch (ex) {
      emit(state.copyWith(validerStatus: AppStatus.error, isOffline: true));
    } catch (ex) {
      emit(state.copyWith(validerStatus: AppStatus.error));
      rethrow;
    }
  }

  void clearProductsQuantity() {
    state.products?.forEach((element) {
      element.quantity = null;
      element.isSelected = false;
    });
  }

  FutureOr<void> _selectLivraison(
      SelectLivraison event, Emitter<AddRetourState> emit) {
    emit(state.copyWith(selectedLivraison: event.livraison));
  }
}
