import 'package:pda/data/data_providers/api/api_client.dart';
import 'package:pda/data/models/activity_client.dart';
import 'package:pda/data/models/bank.dart';
import 'package:pda/data/models/caisse.dart';
import 'package:pda/data/models/chargement.dart';
import 'package:pda/data/models/client.dart';
import 'package:pda/data/models/client_regle_req.dart';
import 'package:pda/data/models/command.dart';
import 'package:pda/data/models/company.dart';
import 'package:pda/data/models/entrepot.dart';
import 'package:pda/data/models/facture.dart';
import 'package:pda/data/models/livraison.dart';
import 'package:pda/data/models/livraison_command_req.dart';
import 'package:pda/data/models/payment_mode.dart';
import 'package:pda/data/models/product.dart';
import 'package:pda/data/models/retour.dart';
import 'package:pda/data/models/tva.dart';
import 'package:pda/data/models/type_client.dart';
import 'package:pda/data/models/user.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/retour.dart';
import 'package:pda/domain/entities/activity_client.dart';
import 'package:pda/domain/entities/bank.dart';
import 'package:pda/domain/entities/caisse.dart';
import 'package:pda/domain/entities/chargement.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/entities/client_reglement_req.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/entities/company.dart';
import 'package:pda/domain/entities/entrepot.dart';
import 'package:pda/domain/entities/facture.dart';
import 'package:pda/domain/entities/livraison_command_req.dart';
import 'package:pda/domain/entities/payment_mode.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/domain/entities/tva.dart';
import 'package:pda/domain/entities/type_client.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/repository/repository.dart';

import '../data_providers/local_db/local_db.dart';










class RepositoryIml extends Repository {

  ApiClient apiClient;
  LocalDB localDB;


  RepositoryIml({required this.apiClient,required this.localDB});

  @override
  Future<UserEntity> login(String email, String password,int company) async{
    UserModel userModel=await apiClient.login(email, password, company);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> getCurrentUser() async{
    UserModel user=await apiClient.getCurrentUser();
    return user.toEntity();
  }

  @override
  Future<List<CompanyEntity>> getCompanies() async{
    List<CompanyModel> companies=await apiClient.getCompanies();
    List<CompanyEntity> companiesE=companies.map((e) => e.toEntity()).toList();
    return companiesE;
  }

  @override
  Future<List<ClientEntity>> getClients(int company) async{
    List<ClientModel> clientsM=await apiClient.getClients(company);
    List<ClientEntity> clientE=clientsM.map((e) => e.toEntity()).toList();
    return clientE;
  }

  @override
  Future<List<TypeClientEntity>> getTypesClients() async{
    List<TypeClientModel> clients=await apiClient.getTypesClient();
    List<TypeClientEntity> clientsE=clients.map((e) => e.toEntity()).toList();
    return clientsE;
  }

  @override
  Future<void> addClient(ClientEntity clientEntity)async {
    ClientModel client=ClientModel.toModel(clientEntity);
    await apiClient.addClient(client);
  }

  @override
  Future<List<EntrepotEntity>> getListEntropot({required int society, required int idType}) async{
      List<EntrepotModel> entrepotM=await apiClient.getListEntropot(society: society,idType: idType);
      List<EntrepotEntity> entrepotE=entrepotM.map((e) => e.toEntity()).toList();
      return entrepotE;
  }

  @override
  Future<List<ProductEntity>> getAllProductsByEntrepot(int idEntrepot) async{
    List<ProductModel> productsM=await apiClient.getAllProductsByEntrepot(idEntrepot);
    List<ProductEntity> productsE=productsM.map((e) => e.toEntity()).toList();
    return productsE;
  }

  @override
  Future<void> addChargement(ChargementEntity chargement) async{
    ChargementModel chargementM=ChargementModel.toModel(chargement);
    await apiClient.addChargement(chargementM);
  }

  @override
  Future<List<ChargementEntity>> getAllChargement(int entrepot) async{
    List<ChargementModel> chargementsM=await apiClient.getAllChargement(entrepot);
    List<ChargementEntity> chargementE=chargementsM.map((e) => e.toEntity()).toList();
    return chargementE;
  }

  @override
  Future<ClientEntity> getClient(int company, int client) async{
    ClientModel clientM=await apiClient.getClient(company, client);
    return clientM.toEntity();
  }

  @override
  Future<List<ActivityClientEntity>> getClientActivities()async {
      List<ActivityClientModel> activitiesM=await apiClient.getClientActivities();
      List<ActivityClientEntity> activitiesE=activitiesM.map((e) => e.toEntity()).toList();
      return activitiesE;
  }

  @override
  Future<List<ProductEntity>> getProductsByClient(int client) async{
    List<ProductModel> productsM=await apiClient.getProductsByClient(client);
    List<ProductEntity> productE=productsM.map((e) => e.toEntity()).toList();
    return productE;
  }

  @override
  Future<List<TvaEntity>> getTvas() async{
    List<TvaModel> tvaM=await apiClient.getTva();
    List<TvaEntity> tvaE=tvaM.map((e) => e.toEntity()).toList();
    return tvaE;
  }

  @override
  Future<void> addCommand(CommandEntity command) async{
    await apiClient.addCommand(CommandModel.toModel(command));
  }

  @override
  Future<List<CommandEntity>> getCommands(int company) async{
    List<CommandModel> commandsM=await apiClient.getCommands(company);
    List<CommandEntity> commandE=commandsM.map((e) => e.toEntity()).toList();
    return commandE;
  }

  @override
  Future<CommandEntity> getCommand(int id) async{
    CommandModel commandModel=await apiClient.getCommand(id);
    return commandModel.toEntity();
  }

  @override
  Future<CommandEntity> validerCommand(int id) async{
    CommandModel command=await apiClient.validerUnCommand(id);
    return command.toEntity();
  }

  @override
  Future<CommandEntity> livrerCommand(LivComdReqEntity request) async{
    CommandModel command=await apiClient.livrerCommand(LivComdReqModel.toModel(request));
    return command.toEntity();
  }

  @override
  Future<List<LivraisonEntity>> getAllLivraison(int company) async{
    List<LivraisonModel> livraisonM=await apiClient.getAllLivraison(company);
    List<LivraisonEntity> livraisonE=livraisonM.map((e) => e.toEntity()).toList();
    return livraisonE;
  }

  @override
  Future<LivraisonEntity> getSingleLivraison(int livraison) async{
    LivraisonModel livraisonRes=await apiClient.getLivraison(livraison);
    return livraisonRes.toEntity();
  }

  @override
  Future<LivraisonEntity> validerLivraison(int livraison)async {
    LivraisonModel livraisonM=await apiClient.validerLivraison(livraison);
    return livraisonM.toEntity();
  }

  @override
  Future<List<BankEntity>> getBanks() async{
    List<BankModel> banksM=await apiClient.getBanks();
    List<BankEntity> bankE=banksM.map((e) => e.toEntity()).toList();
    return bankE;
  }

  @override
  Future<List<CaisseEntity>> getCaisses() async{
    List<CaisseModel> caisses=await apiClient.getCaisses();
    List<CaisseEntity> caissesE=caisses.map((e) => e.toEntity()).toList();
    return caissesE;
  }

  @override
  Future<List<PaymentModeEntity>> getPayments() async{
    List<PaymentModeModel> paymentsM=await apiClient.getPayments();
    List<PaymentModeEntity> paymentsE=paymentsM.map((e) => e.toEntity()).toList();
    return paymentsE;
  }

  @override
  Future<List<FactureEntity>> getFacturesNotPaid(int client,int company) async{
    List<FactureModel> facturesM=await apiClient.getFacturesNotPaid(client,company);
    List<FactureEntity> facturesE=facturesM.map((e) => e.toEntity()).toList();
    return facturesE;
  }

  @override
  Future<void> addReglement(ClientRegReqEntity request) async{
    ClientRegReqModel clientRegReqModel=ClientRegReqModel.toModel(request);
    await apiClient.addReglement(clientRegReqModel);
  }

  @override
  Future<List<RetourEntity>> retours(int company)async {
    List<RetourModel> retours=await apiClient.getRetours(company);
    List<RetourEntity> retoursE=retours.map((e) => e.toEntity()).toList();
    return retoursE;
  }

  @override
  Future<void> addRetour(RetourEntity retour) async{
    await apiClient.addRetour(RetourModel.toModel(retour));
  }

  @override
  Future<RetourEntity> getRetourDetails(int retourId)async {
    RetourModel retour=await apiClient.getRetourDetails(retourId);
    return retour.toEntity();
  }

  @override
  Future<List<EntrepotEntity>> getEntrepotsByUser() async{
    List<EntrepotModel> entrepots=await apiClient.getEntrepotByUser();
    List<EntrepotEntity> entrepotE=entrepots.map((e) => e.toEntity()).toList();
    return entrepotE;
  }

  @override
  Future<List<ProductEntity>> getProductsByEntrepot(int entrepot)async {
    List<ProductModel> products=await apiClient.getProductsByEntrepot(entrepot);
    List<ProductEntity> productsE=products.map((e) => e.toEntity()).toList();
    return productsE;
  }

  @override
  Future<CompanyEntity> getCompany(int companyId) async{
    CompanyModel company=await apiClient.getCompany(companyId);
    return company.toEntity();
  }

  @override
  Future<LivraisonEntity> facturableLivraison(int liv) async{
      LivraisonModel livRes=await apiClient.facturableLivraison(liv);
      return livRes.toEntity();
  }

  @override
  Future<void> addLivraison(LivraisonEntity livraison) async{
    await apiClient.addLivraison(LivraisonModel.toModel(livraison));
  }

  @override
  Future<List<LivraisonEntity>> getLivraisonsByClient(int client, int company) async{
    List<LivraisonModel> livraisons=await apiClient.getLivraisonsByClient(client, company);
    List<LivraisonEntity> livraisonE=livraisons.map((e) => e.toEntity()).toList();
    return livraisonE;
  }

  @override
  Future<RetourEntity> livrerRetour(int retourId)async {
    RetourModel livraison=await apiClient.livrerRetour(retourId);
    return livraison.toEntity();
  }

  @override
  Future<void> addCommandToLocal(CommandEntity command) async{
    CommandModel commandM=CommandModel.toModel(command);
    await localDB.insertCommand(commandM);
  }

  @override
  Future<void> addProductToLocal(ProductEntity product) async{
    ProductModel productM=ProductModel.toModel(product);
    await localDB.insertProduct(productM);
  }

  RepositoryIml copyWith({
    ApiClient? apiClient,
    LocalDB? localDB,
  }) {
    return RepositoryIml(
      apiClient: apiClient ?? this.apiClient,
      localDB: localDB ?? this.localDB,
    );
  }

  @override
  Future<List<LivraisonEntity>> getLivraisonByDate(int comany, String date) async{
    List<LivraisonModel> livraisons=await apiClient.getLivraisonsByDate(comany, date);
    List<LivraisonEntity> livraisonE=livraisons.map((e) => e.toEntity()).toList();
    return livraisonE;
  }

  @override
  Future<List<CommandEntity>> getCommandsNotSent() async{
    List<CommandModel> commands=await localDB.getCommandNotSent();
    List<CommandEntity> commandsE=commands.map((e) => e.toEntity()).toList();
    return commandsE;
  }

  @override
  Future<List<ProductEntity>> getProductsNotSent()async {
    List<ProductModel> products=await localDB.getProductsNotSent();
    List<ProductEntity> productsE=products.map((e) => e.toEntity()).toList();
    return productsE;
  }

  @override
  Future<int> getCountProductsNotSent() async{
    int count=await localDB.getCountProductsNotSent();
    return count;
  }

  @override
  Future<void> updateSentProducts() async {
    await localDB.updateSentProducts();
  }
}