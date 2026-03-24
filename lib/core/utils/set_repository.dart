import 'dart:async';

import 'package:pda/data/data_providers/local_db/local_db.dart';

import '../../config.dart';
import '../../data/data_providers/api/api_client.dart';
import '../../data/repository/repository.dart';
import '../../domain/repository/repository.dart';
import '../dependencies/dependencies.dart';
import '../services/shared_pref_service.dart';



Future<void> setRepository()async{
  SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
  String token=sharedPrefService.getValue(SharedPrefService.token, "");
  ApiClient apiClient=ApiClientIml(baseUrl: baseUrl,token: token);
  LocalDB localDB=await LocalDB.initialise();
  Repository repository=RepositoryIml(apiClient: apiClient,localDB: localDB);
  Dependencies.put(repository);
}