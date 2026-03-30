import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';

import 'core/themes/light_theme/light_theme.dart';
import 'core/utils/set_repository.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prepareDependencies();
  runApp(const MyApp());
}

Future<void> prepareDependencies() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SharedPrefService sharedPrefService =
      await SharedPrefService.initializeService();
  CoreBloc coreBloc = CoreBloc();
  Dependencies.put(coreBloc);
  Dependencies.put(sharedPrefService);
  await setRepository();

  //=====================test
  /*Repository repository=Dependencies.get<Repository>();
  List<ProductEntity> products=await repository.getProductsNotSent();
  products.forEach((element) {print(element.toString());});*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp.router(
        title: 'PVM',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        routerConfig: Routes.router,
      ),
    );
  }
}
