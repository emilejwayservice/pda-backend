import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pda/core/utils/set_repository.dart';


import '../../routes.dart';
import '../dependencies/dependencies.dart';
import '../services/shared_pref_service.dart';


void logout(BuildContext context){
  SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
  sharedPrefService.removeRecord(SharedPrefService.token);
  setRepository();
  while(Navigator.canPop(context)){
    Navigator.pop(context);
  }
  GoRouter.of(context).replace(Routes.login);
}