import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pda/data/models/activity_client.dart';
import 'package:pda/data/models/bank.dart';
import 'package:pda/data/models/caisse.dart';
import 'package:pda/data/models/chargement.dart';
import 'package:pda/data/models/client.dart';
import 'package:pda/data/models/client_regle_req.dart';
import 'package:pda/data/models/command.dart';
import 'package:pda/data/models/entrepot.dart';
import 'package:pda/data/models/facture.dart';
import 'package:pda/data/models/livraison.dart';
import 'package:pda/data/models/livraison_command_req.dart';
import 'package:pda/data/models/payment_mode.dart';
import 'package:pda/data/models/product.dart';
import 'package:pda/data/models/reception_model.dart';
import 'package:pda/data/models/retour.dart';
import 'package:pda/data/models/tva.dart';
import 'package:pda/data/models/type_client.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/exceptions/server_exception.dart';

import '../../../domain/exceptions/unauthenticated_exception.dart';
import '../../models/company.dart';
import '../../models/user.dart';

abstract class ApiClient {
  Future<UserModel> login(String email, String password, int company);
  Future<UserModel> getCurrentUser();
  Future<List<CompanyModel>> getCompanies();
  Future<List<ClientModel>> getClients(int company);
  Future<List<TypeClientModel>> getTypesClient();
  Future<void> addClient(ClientModel client);
  Future<List<EntrepotModel>> getListEntropot(
      {required int society, required int idType});
  Future<List<ProductModel>> getAllProductsByEntrepot(int idEntrepot);
  Future<void> addChargement(ChargementModel chargement);
  Future<List<ChargementModel>> getAllChargement(int entrepot);
  Future<ClientModel> getClient(int company, int client);
  Future<List<ActivityClientModel>> getClientActivities();
  Future<List<ProductModel>> getProductsByClient(int client);
  Future<List<TvaModel>> getTva();
  Future<void> addCommand(CommandModel command);
  Future<List<CommandModel>> getCommands(int company);
  Future<CommandModel> getCommand(int id);
  Future<CommandModel> validerUnCommand(int id);
  Future<CommandModel> livrerCommand(LivComdReqModel request);
  Future<List<LivraisonModel>> getAllLivraison(int company);
  Future<LivraisonModel> getLivraison(int livraison);
  Future<LivraisonModel> validerLivraison(int livraison);
  Future<List<PaymentModeModel>> getPayments();
  Future<List<CaisseModel>> getCaisses();
  Future<List<BankModel>> getBanks();
  Future<List<FactureModel>> getFacturesNotPaid(int client, int company);
  Future<void> addReglement(ClientRegReqModel request);
  Future<List<RetourModel>> getRetours(int company);
  Future<void> addRetour(RetourModel retour);
  Future<RetourModel> getRetourDetails(int retour);
  Future<List<EntrepotModel>> getEntrepotByUser();
  Future<List<ProductModel>> getProductsByEntrepot(int entrepot);
  Future<CompanyModel> getCompany(int id);
  Future<LivraisonModel> facturableLivraison(int id);
  Future<void> addLivraison(LivraisonModel livraison);
  Future<List<LivraisonModel>> getLivraisonsByClient(int client, int company);
  Future<RetourModel> livrerRetour(int id);
  Future<List<LivraisonModel>> getLivraisonsByDate(int company, String date);
  Future<ReceptionModel> createReception(Map<String, dynamic> data);
  Future<List<ReceptionModel>> getReceptions();
  Future<ReceptionDetailModel> createReceptionDetail(
      int receptionId, Map<String, dynamic> data);
  Future<List<ReceptionDetailModel>> getReceptionDetails();
  Future<List<ReceptionDetailModel>> getReceptionDetailsByReception(
      int receptionId);
  Future<List<FournisseurModel>> getFournisseurs();
  Future<List<EntrepotReceptionModel>> getEntrepots(int idSociete);
  Future<List<ArticleModel>> getArticles(int idSociete);
  Future<List<BateauModel>> getBateaux();
  Future<List<UniteModel>> getUnites();
  Future<NextRefModel> getNextRef();
  Future<ArticleUnitModel> getArticleUnit(int idArticle);
}

class ApiClientIml extends ApiClient {
  late Dio _dio;

  ApiClientIml({required String baseUrl, String? token}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      headers: {"Authorization": "Bearer ${token}"},
      connectTimeout: const Duration(seconds: 20),
    ))
      ..interceptors.add(LogInterceptor(
        error: true,
        responseHeader: true,
        responseBody: true,
        requestHeader: true,
        requestBody: true,
        request: true,
      ));
  }

  @override
  Future<UserModel> login(String email, String password, int company) async {
    try {
      var response = await _dio.post("/login",
          data: {"email": email, "password": password, "fk_societe": company});
      UserModel userModel = UserModel.fromJson(response.data);
      return userModel;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      var response = await _dio.get(
        "/me",
      );
      UserModel userModel = UserModel.fromJson(response.data);
      return userModel;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<CompanyModel>> getCompanies() async {
    try {
      var response =
          await _dio.get("/getAllSocietes", options: Options(headers: {}));
      List<CompanyModel> companies =
          (response.data as List).map((e) => CompanyModel.fromJson(e)).toList();
      return companies;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<ClientModel>> getClients(int company) async {
    try {
      var response = await _dio.get("/clients/${company}");
      List<ClientModel> clients =
          (response.data as List).map((e) => ClientModel.fromJson(e)).toList();
      return clients;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<TypeClientModel>> getTypesClient() async {
    try {
      var response = await _dio.get("/clients/types");
      List<TypeClientModel> types = (response.data as List)
          .map((e) => TypeClientModel.fromJson(e))
          .toList();
      return types;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<void> addClient(ClientModel client) async {
    try {
      var response = await _dio.post('/clients', data: client.toJson());
    } on DioException catch (ex) {
      print(
          "=======================status code =============================${ex.response?.statusCode}");
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getAllProductsByEntrepot(int idEntrepot) async {
    try {
      var response = await _dio.get("/products/${idEntrepot}");
      List<ProductModel> products =
          (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<EntrepotModel>> getListEntropot(
      {required int society, required int idType}) async {
    try {
      var response = await _dio.get("/entrepots/${society}/${idType}");
      List<EntrepotModel> entrepots = (response.data as List)
          .map((e) => EntrepotModel.fromJson(e))
          .toList();
      return entrepots;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<void> addChargement(ChargementModel chargement) async {
    try {
      var response = await _dio.post("/chargements", data: chargement.toJson());
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<ChargementModel>> getAllChargement(int entrepot) async {
    try {
      var response = await _dio.get("/chargements/${entrepot}");
      List<ChargementModel> chargements = (response.data as List)
          .map((e) => ChargementModel.fromJson(e))
          .toList();
      return chargements;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<ClientModel> getClient(int company, int client) async {
    try {
      var response = await _dio.get("/clients/details/${client}/${company}");
      ClientModel clientResponse = ClientModel.fromJson(response.data);
      return clientResponse;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<ActivityClientModel>> getClientActivities() async {
    try {
      var response = await _dio.get("/clients/activities");
      List<ActivityClientModel> activities = (response.data as List)
          .map((e) => ActivityClientModel.fromJson(e))
          .toList();
      return activities;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByClient(int client) async {
    try {
      var response = await _dio.get("/products/by-client/${client}");
      List<ProductModel> products =
          (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<TvaModel>> getTva() async {
    try {
      var response = await _dio.get("/tva");
      List<TvaModel> tva =
          (response.data as List).map((e) => TvaModel.fromJson(e)).toList();
      return tva;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<void> addCommand(CommandModel command) async {
    try {
      var response = await _dio.post("/commands", data: command.toJson());
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<CommandModel>> getCommands(int company) async {
    try {
      var response = await _dio.get("/commands/${company}");
      List<CommandModel> commands =
          (response.data as List).map((e) => CommandModel.fromMap(e)).toList();
      return commands;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<CommandModel> getCommand(int id) async {
    try {
      var response = await _dio.get("/commands/single/${id}");
      CommandModel commandModel = CommandModel.fromMap(response.data);
      return commandModel;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<CommandModel> validerUnCommand(int id) async {
    try {
      var response = await _dio.patch("/commands/valider/${id}");
      CommandModel commandModel = CommandModel.fromMap(response.data);
      return commandModel;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<CommandModel> livrerCommand(LivComdReqModel request) async {
    try {
      var response =
          await _dio.post("/commands/livrer", data: request.toJson());
      CommandModel commandModel = CommandModel.fromMap(response.data);
      return commandModel;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<LivraisonModel>> getAllLivraison(int company) async {
    try {
      var response = await _dio.get("/livraisons/${company}");
      List<LivraisonModel> livraisons = (response.data as List)
          .map((e) => LivraisonModel.fromMap(e))
          .toList();
      return livraisons;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<LivraisonModel> getLivraison(int livraison) async {
    try {
      var response = await _dio.get("/livraisons/single/${livraison}");
      LivraisonModel livraisonRes = LivraisonModel.fromMap(response.data);
      return livraisonRes;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<LivraisonModel> validerLivraison(int livraison) async {
    try {
      var response = await _dio.patch("/livraisons/valider/${livraison}");
      LivraisonModel livraisonRes = LivraisonModel.fromMap(response.data);
      return livraisonRes;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<BankModel>> getBanks() async {
    try {
      var response = await _dio.get("/reglements/banques");
      List<BankModel> banks =
          (response.data as List).map((e) => BankModel.fromJson(e)).toList();
      return banks;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<CaisseModel>> getCaisses() async {
    try {
      var response = await _dio.get("/reglements/caisses");
      List<CaisseModel> caisses =
          (response.data as List).map((e) => CaisseModel.fromJson(e)).toList();
      return caisses;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<FactureModel>> getFacturesNotPaid(int client, int company) async {
    try {
      var response = await _dio.get("/factures/not-paid/${client}/${company}");
      List<FactureModel> factures =
          (response.data as List).map((e) => FactureModel.fromMap(e)).toList();
      return factures;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<PaymentModeModel>> getPayments() async {
    try {
      var response = await _dio.get("/reglements/payments-modes");
      List<PaymentModeModel> paymentModes = (response.data as List)
          .map((e) => PaymentModeModel.fromJson(e))
          .toList();
      return paymentModes;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<void> addReglement(ClientRegReqModel request) async {
    try {
      await _dio.post("/reglements", data: request.toJson());
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<RetourModel>> getRetours(int company) async {
    try {
      var response = await _dio.get("/retours/${company}");
      List<RetourModel> retours =
          (response.data as List).map((e) => RetourModel.fromJson(e)).toList();
      return retours;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<void> addRetour(RetourModel retour) async {
    try {
      var response = await _dio.post("/retours", data: retour.toJson());
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<RetourModel> getRetourDetails(int retourId) async {
    try {
      var response = await _dio.get("/retours/details/${retourId}");
      RetourModel retour = RetourModel.fromJson(response.data);
      return retour;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<EntrepotModel>> getEntrepotByUser() async {
    try {
      var response = await _dio.get("/entrepots/by-user");
      List<EntrepotModel> entrepots = (response.data as List)
          .map((e) => EntrepotModel.fromJson(e))
          .toList();
      return entrepots;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByEntrepot(int entrepot) async {
    try {
      var response = await _dio.get("/products/by-entrepot/${entrepot}");
      List<ProductModel> products =
          (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<CompanyModel> getCompany(int id) async {
    try {
      var response = await _dio.get("/societes/${id}");
      CompanyModel company = CompanyModel.fromJson(response.data);
      return company;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<LivraisonModel> facturableLivraison(int id) async {
    try {
      var response = await _dio.patch("/livraisons/facturable/${id}");
      LivraisonModel liv = LivraisonModel.fromMap(response.data);
      return liv;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<void> addLivraison(LivraisonModel livraison) async {
    try {
      var response = await _dio.post("/livraisons", data: livraison.toJson());
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<LivraisonModel>> getLivraisonsByClient(
      int client, int company) async {
    try {
      var response = await _dio.get("/livraisons/${company}/${client}");
      List<LivraisonModel> livraison = (response.data as List)
          .map((e) => LivraisonModel.fromMap(e))
          .toList();
      return livraison;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<RetourModel> livrerRetour(int id) async {
    try {
      var response = await _dio.patch("/retours/livrer/${id}");
      RetourModel retour = RetourModel.fromJson(response.data);
      return retour;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<List<LivraisonModel>> getLivraisonsByDate(
      int company, String date) async {
    try {
      var response = await _dio
          .get("/livraisons/by-date/$company", queryParameters: {"date": date});
      List<LivraisonModel> livraisons = await (response.data as List)
          .map((e) => LivraisonModel.fromMap(e))
          .toList();
      return livraisons;
    } on DioException catch (ex) {
      if (ex.error is SocketException ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw NetworkConnectivityException();
      }
      if ((ex.response?.statusCode ?? 0) == 401 ||
          (ex.response?.statusCode ?? 0) == 403) {
        throw UnAuthenticatedException();
      }
      if ((ex.response?.statusCode ?? 0) == 400) {
        throw ServerException(ex.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<ReceptionModel> createReception(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/receptions', data: data);
      return ReceptionModel.fromJson(response.data);
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<ReceptionModel>> getReceptions() async {
    try {
      final response = await _dio.get('/receptions');
      return (response.data as List)
          .map((e) => ReceptionModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<ReceptionDetailModel>> getReceptionDetailsByReception(
      int receptionId) async {
    try {
      final response = await _dio.get('/reception-details/$receptionId');
      return (response.data as List)
          .map((e) => ReceptionDetailModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<ReceptionDetailModel> createReceptionDetail(
      int receptionId, Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post('/reception-details/$receptionId', data: data);
      return ReceptionDetailModel.fromJson(response.data);
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<ReceptionDetailModel>> getReceptionDetails() async {
    try {
      final response = await _dio.get('/reception-details');
      return (response.data as List)
          .map((e) => ReceptionDetailModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<FournisseurModel>> getFournisseurs() async {
    try {
      final response = await _dio.get('/receptions/fournisseurs');
      return (response.data as List)
          .map((e) => FournisseurModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<EntrepotReceptionModel>> getEntrepots(int idSociete) async {
    try {
      final response = await _dio.get(
        '/receptions/entrepots',
        queryParameters: {'idSociete': idSociete},
      );
      return (response.data as List)
          .map((e) => EntrepotReceptionModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<ArticleModel>> getArticles(int idSociete) async {
    try {
      final response = await _dio.get(
        '/reception-details/articles',
        queryParameters: {'idSociete': idSociete},
      );
      return (response.data as List)
          .map((e) => ArticleModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<BateauModel>> getBateaux() async {
    try {
      final response = await _dio.get('/reception-details/bateaux');
      return (response.data as List)
          .map((e) => BateauModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<List<UniteModel>> getUnites() async {
    try {
      final response = await _dio.get('/reception-details/unities');
      return (response.data as List)
          .map((e) => UniteModel.fromJson(e))
          .toList();
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<NextRefModel> getNextRef() async {
    try {
      final response = await _dio.get('/receptions/next-ref');
      return NextRefModel.fromJson(response.data);
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  @override
  Future<ArticleUnitModel> getArticleUnit(int idArticle) async {
    try {
      final response = await _dio.get('/receptions/$idArticle/unit');
      return ArticleUnitModel.fromJson(response.data);
    } on DioException catch (ex) {
      _handleDioException(ex);
      rethrow;
    }
  }

  void _handleDioException(DioException ex) {
    if (ex.error is SocketException ||
        ex.type == DioExceptionType.connectionTimeout) {
      throw NetworkConnectivityException();
    }
    if ((ex.response?.statusCode ?? 0) == 401 ||
        (ex.response?.statusCode ?? 0) == 403) {
      throw UnAuthenticatedException();
    }
    if ((ex.response?.statusCode ?? 0) == 400) {
      throw ServerException(ex.response!.data);
    }
  }
}
