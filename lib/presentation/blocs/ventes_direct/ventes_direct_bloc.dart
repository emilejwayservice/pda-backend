import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/tva.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import '../../../domain/entities/product.dart';

part 'ventes_direct_event.dart';
part 'ventes_direct_state.dart';

class VentesDirectBloc extends Bloc<VentesDirectEvent, VentesDirectState> {
  VentesDirectBloc() : super(VentesDirectState(dateLivraison: DateTime.now())) {
    on<FetchData>(_fetchData);
    on<SelectDate>(_selectDate);
    on<SelectClient>(_selectClient);
    on<ProductSelected>(_onProductSelected);
    on<CheckCartStatus>(_checkCartStatus);
    on<AddVente>(_addVente);
  }

  FutureOr<void> _fetchData(
      FetchData event, Emitter<VentesDirectState> emit) async {
    try {
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      int company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      Repository repository = Dependencies.get<Repository>();
      var result = await Future.wait([
        repository.getTvas(),
        repository.getClients(company),
      ]);
      List<TvaEntity> tvas = result[0] as List<TvaEntity>;
      List<ClientEntity> clients = result[1] as List<ClientEntity>;
      emit(state.copyWith(
          fetchDataStatus: AppStatus.success, tvas: tvas, clients: clients));
    } on NetworkConnectivityException {
      emit(state.copyWith(fetchDataStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  FutureOr<void> _selectDate(
      SelectDate event, Emitter<VentesDirectState> emit) {
    emit(state.copyWith(dateLivraison: event.selectedDate));
  }

  FutureOr<void> _selectClient(
      SelectClient event, Emitter<VentesDirectState> emit) async {
    try {
      emit(state.copyWith(
          fetchProductsStatus: AppStatus.loading,
          selectedClient: event.client));
      Repository repository = Dependencies.get<Repository>();
      List<ProductEntity> products =
          await repository.getProductsByClient(event.client.id!);
      emit(state.copyWith(
          fetchProductsStatus: AppStatus.success,
          products: products,
          displayedProducts: products));
    } on NetworkConnectivityException {
      emit(state.copyWith(
          fetchProductsStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(fetchProductsStatus: AppStatus.error));
    }
  }

  FutureOr<void> _onProductSelected(
      ProductSelected event, Emitter<VentesDirectState> emit) {
    emit(state.copyWith());
  }

  FutureOr<void> _checkCartStatus(
      CheckCartStatus event, Emitter<VentesDirectState> emit) async {
    if (state.products?.isEmpty ?? true) return;
    if (state.getSelectedProducts().isEmpty) return;
    emit(state.copyWith(cartStatus: AppStatus.success));
  }

  FutureOr<void> _addVente(
      AddVente event, Emitter<VentesDirectState> emit) async {
    try {
      emit(state.copyWith(addVenteStatus: AppStatus.loading));
      int company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      UserEntity user = Dependencies.get<UserEntity>();
      List<ProductEntity> selectedProducts = state.getSelectedProducts();
      List<LivraisonDetailEntity> details = [];
      for (ProductEntity prod in selectedProducts) {
        details.add(LivraisonDetailEntity(
          tva: prod.tva?.toDouble(),
          price: prod.price,
          quantity: prod.quantity?.toDouble(),
          product: prod,
        ));
      }
      LivraisonEntity livraison = LivraisonEntity(
        idCompany: company,
        idClient: state.selectedClient?.id,
        idEntrepot: user.idCamion,
        details: details,
        dateLaivraison: state.dateLivraison,
      );
      Repository repository = Dependencies.get<Repository>();
      await repository.addLivraison(livraison);

      for (var e in selectedProducts) {
        e.isSelected = false;
        e.quantity = 0;
      }

      CoreBloc core = Dependencies.get<CoreBloc>();
      core.add(UpdateLivraison());
      core.add(UpdateClients());

      emit(state.copyWith(addVenteStatus: AppStatus.success));
    } on NetworkConnectivityException {
      emit(state.copyWith(addVenteStatus: AppStatus.error, isOffline: true));
    } catch (_) {
      emit(state.copyWith(addVenteStatus: AppStatus.error));
      rethrow;
    }
  }
}
