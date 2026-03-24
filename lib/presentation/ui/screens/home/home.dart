import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_images.dart';
import 'package:pda/core/utils/logout.dart';
import 'package:pda/core/utils/show_dialogue_question.dart';
import 'package:pda/presentation/ui/screens/home/components/grid_tile.dart';

import '../../../../routes.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    return Scaffold(
        body:Stack(
        children: [
          Container(
            width: width,
            height: height,
            color: AppColors.primaryColor,
          ),
          SafeArea(
            child: Column(
              children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     //SizedBox(),
                     Image.asset(AppImages.app_logo,height: 50,),
                     IconButton(
                         onPressed:onLogout,
                         icon: Icon(Icons.logout,color: Colors.white,)
                     ),
                   ],
                 ),
               ),
                const SizedBox(height: 10,),
                Expanded(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                        color: Colors.white
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                          child: StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 17,
                            crossAxisSpacing: 8,
                            children:  [
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 3,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    image: AppImages.ic_ventes,
                                    name: "Ventes Direct",
                                    isVertival: false,
                                    route: Routes.ventes,
                                    onClick: navigate,
                                  )
                              ),
                              /*StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: MyGridTile(
                                  name: "Commandes",
                                  image: AppImages.ic_shoping_cart,
                                  isVertival: false,
                                  route: Routes.commands,
                                  onClick: navigate,
                                )
                              ),*/
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    name: "Pre Commandes",
                                    image: AppImages.ic_shoping_cart,
                                    isVertival: false,
                                    route: Routes.preCommand,
                                    onClick: navigate,
                                  )
                              ),
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    name: "Clients",
                                    image: AppImages.ic_users,
                                    route: Routes.clients,
                                    onClick: navigate,
                                  )
                              ),
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    image: AppImages.ic_retour,
                                    name: "Retour",
                                    route: Routes.retour,
                                    onClick: navigate,
                                  )
                              ),
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    name: "Livraison",
                                    image: AppImages.ic_delivry,
                                    isVertival: false,
                                    onClick: navigate,
                                    route: Routes.livraison,
                                  )
                              ),

                              StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: 1,
                                  child:MyGridTile(
                                    name: "Chargements",
                                    image: AppImages.ic_chargement,
                                    isVertival: false,
                                    route: Routes.chargement,
                                    onClick: navigate,
                                  )
                              ),
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    image: AppImages.ic_warehouse,
                                    name: "Stock",
                                    onClick: navigate,
                                    route: Routes.stock,
                                  )
                              ),

                              StaggeredGridTile.count(
                                  crossAxisCellCount: 3,
                                  mainAxisCellCount: 1,
                                  child: MyGridTile(
                                    image: AppImages.ic_historique,
                                    name: "Historique",
                                    onClick: navigate,
                                    isVertival: false,
                                    route: Routes.livraisonHistorique,
                                  )
                              ),




                              /*StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child:MyGridTile(
                                  image: AppImages.ic_bankcard,
                                  name: "Reglements",
                                  onClick: navigate,
                                  route: "",
                                )
                              ),*/
                            ],
                          ),
                        )
                      ),
                    )
                )
              ],
            ),
          )
        ],
      )
    );
  }

  void navigate(String route) {
    if(route.isEmpty){
      Fluttertoast.showToast(
          msg: "En développement",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }
    GoRouter.of(context).push(route);
  }

  void onLogout() async{
    var result=await showDialogueQuestion(context, "Voulez-vous vraiment vous déconnecter ?","Oui","Non");
    if(result!=null && result){
      logout(context);
    }
  }
}




