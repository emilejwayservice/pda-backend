

import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/company.dart';
import 'package:pda/presentation/ui/screens/add_retour/add_retour.dart';
import 'presentation/ui/screens/screens.dart';


class Routes{

  static const String login="/login";
  static const String register="/register";
  static const String home="/";
  static const String resetPassword="/reset-password";
  static const String initializer="/initialiser";

  static const String chargement="/chargement";
  static const String clients="/clients";
  static const String commands="/commands";
  static const String singleCommand="/commands/:id";
  static const String livraison="/livraison";
  static const String livraisonDetails="/livraison/:id";
  static const String reglement="/reglement";
  static const String clientReglement="/client-reglement/:id";
  static const String retour="/retour";
  static const String stock="/stock";
  static const String ventes="/ventes";

  static const String addChargement="/add-chargement";
  static const String clientDetails="/client-details/:id";
  static const String addClient="/add-client";
  static const String addCommand="/add-command";
  static const String addRetour="/add-retour";
  static const String retourDetails="/retour-details/:id";
  static const String scanner="/scanner";
  static const String livraisonHistorique="/historique-livraison";
  static const String preCommand="/pre-command";




  static GoRouter router=GoRouter(
      initialLocation: login,
      routes: [
       StatefulShellRoute.indexedStack(
           pageBuilder: (ctx,state,navigationShell){
             return NoTransitionPage(child: AuthContainer(navigationShell));
           },
           branches: [
             StatefulShellBranch(
                 routes: [
                   GoRoute(
                       path: login,
                      redirect: (context,state){
                         bool isContainCompanies=Dependencies.contain<List<CompanyEntity>>();
                         bool isContainToken=Dependencies.get<SharedPrefService>().contains(SharedPrefService.token);
                         if(!isContainCompanies || isContainToken ){
                           return initializer;
                         }
                      },
                      pageBuilder: (context,state)=> NoTransitionPage(child:LoginScreen.page())
                   )
                 ]
             ),
             StatefulShellBranch(
                 routes: [
                   GoRoute(
                       path: register,
                       pageBuilder: (context,state)=>const NoTransitionPage(child:RegisterScreen())
                   )
                 ]
             ),
             StatefulShellBranch(
                 routes: [
                   GoRoute(
                       path: resetPassword,
                       pageBuilder: (context,state)=>const NoTransitionPage(child:ResetPasswordScreen())
                   )
                 ]
             ),
             StatefulShellBranch(
                 routes: [
                   GoRoute(
                       path: initializer,
                       pageBuilder: (context,state)=> NoTransitionPage(child:InitialiserScreen.page())
                   )
                 ]
             ),

           ]
       ),
        GoRoute(
            path:home,
          pageBuilder: (context,state)=> CustomTransitionPage(
              child: HomeScreen(),
              transitionsBuilder: (context,animation,scondaryAnimation,child){
                const begin= Offset(1.0, -1.0);
                const end=Offset.zero;
                final tween=Tween(begin: begin,end: end);
                final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                final anim=tween.animate(curvedAnimation);
                return SlideTransition(
                  position: anim,
                  child: child,
                );
              }
          )
        ),
        GoRoute(
            path:commands,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: CommandScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:clients,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: ClientsScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:chargement,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: ChargementScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:livraison,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: LivraisonScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:reglement,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: ReglementScreen(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:retour,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: RetourScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:stock,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: StockScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:ventes,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: VentesScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(-1.0, -1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:addChargement,
            pageBuilder: (context,state)=> CustomTransitionPage(
                child: AddChargementScreen.page(),
                transitionsBuilder: (context,animation,scondaryAnimation,child){
                  const begin= Offset(1.0, 1.0);
                  const end=Offset.zero;
                  final tween=Tween(begin: begin,end: end);
                  final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  final anim=tween.animate(curvedAnimation);
                  return SlideTransition(
                    position: anim,
                    child: child,
                  );
                }
            )
        ),
        GoRoute(
            path:clientDetails,
            pageBuilder: (context,state){
              int idClient=int.parse(state.pathParameters["id"]!);
              return CustomTransitionPage(
                  child: ClientDetailsScreen.page(idClient),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0, 0.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }
        ),
        GoRoute(
            path:addClient,
            pageBuilder: (context,state){

              return CustomTransitionPage(
                  child: AddClientScreen.page(),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0, 1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }
        ),
        GoRoute(
            path:addCommand,
            pageBuilder: (context,state){

              return CustomTransitionPage(
                  child: AddCommandScreen.page(),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0, 1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }
        ),
        GoRoute(
            path:singleCommand,
            pageBuilder: (context,state){
              int id=int.parse(state.pathParameters['id'].toString());
              return CustomTransitionPage(
                  child: SingleCommandScreen.page(id),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0, 1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),
        GoRoute(
            path:livraisonDetails,
            pageBuilder: (context,state){
              int id=int.parse(state.pathParameters['id'].toString());
              return CustomTransitionPage(
                  child: LivraisonDetailsScreen.page(id),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0, 0.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),

        GoRoute(
            path:clientReglement,
            pageBuilder: (context,state){
              int id=int.parse(state.pathParameters['id'].toString());
              return CustomTransitionPage(
                  child: ClientReglementScreen.page(id),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(0.0, -1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),
        GoRoute(
            path:addRetour,
            pageBuilder: (context,state){

              return CustomTransitionPage(
                  child: AddRetourScreen.page(),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0,1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),

        GoRoute(
            path:retourDetails,
            pageBuilder: (context,state){
              int id=int.parse(state.pathParameters['id'].toString());
              return CustomTransitionPage(
                  child: RetourDetailsScreen.page(id),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(1.0,1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),


        GoRoute(
            path:scanner,
            pageBuilder: (context,state){
              return CustomTransitionPage(
                  child: QrScannerScreen(),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(0.0,-1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),



        GoRoute(
            path:livraisonHistorique,
            pageBuilder: (context,state){
              return CustomTransitionPage(
                  child: LivraisonHistoriqueScreen.page(),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(-1.0,-1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),


        GoRoute(
            path:preCommand,
            pageBuilder: (context,state){
              return CustomTransitionPage(
                  child: PreCommand.page(),
                  transitionsBuilder: (context,animation,scondaryAnimation,child){
                    const begin= Offset(-1.0,-1.0);
                    const end=Offset.zero;
                    final tween=Tween(begin: begin,end: end);
                    final curvedAnimation=CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                    final anim=tween.animate(curvedAnimation);
                    return SlideTransition(
                      position: anim,
                      child: child,
                    );
                  }
              );
            }

        ),




      ]
  );

}