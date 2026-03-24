import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/core/services/qr_payload.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/presentation/blocs/livraison/livraisons_bloc.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';

import '../../../../routes.dart';


class LivraisonScreen extends StatefulWidget {

  LivraisonScreen({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<LivraisonsBloc>(
        create: (context)=>LivraisonsBloc(),
      child: LivraisonScreen(),
    );
  }

  @override
  State<LivraisonScreen> createState() => _LivraisonScreenState();
}

class _LivraisonScreenState extends State<LivraisonScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Livraisons",
        action: IconButton(
          icon: Icon(Icons.qr_code_scanner,color: Colors.white,),
          onPressed: onScann,
        ),
      ),
      body: Column(
        children: [
          BlocListener<LivraisonsBloc,LivraisonsState>(
              listener: listener,
            child: SizedBox(),
          ),
          Expanded(
              child: BlocBuilder<LivraisonsBloc,LivraisonsState>(
                builder: (context,state){
                  if(state.fetchDataStatus==AppStatus.loading){
                    return Center(child: LoadingWidget(),);
                  }else if(state.fetchDataStatus==AppStatus.error){
                    return OfflineErrodWidget(isOffline: state.isOffline??false,error: state.error,action: fetchData,);
                  }else if(state.fetchDataStatus==AppStatus.success){
                    return ListView.builder(
                      itemCount: state.livraisons?.length??0,
                        itemBuilder: (context,index){
                            LivraisonEntity livraison=state.livraisons!.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.only(left: 18.0,right: 18.0,top: 27),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ListTile(
                                    onTap: ()=>onLIvraisonClick(livraison,context),
                                    contentPadding: const EdgeInsets.symmetric(vertical:13 ,horizontal: 16),
                                    tileColor: Colors.grey[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    title: Text(livraison.dateLaivraison?.formattedDateFr??"-",
                                      style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18,fontWeight:FontWeight.bold),) ,
                                    trailing: Text(livraison.totalTTC?.toString()??"-",style: GoogleFonts.aBeeZee(color:Colors.green,fontSize:18,fontWeight:FontWeight.w700),),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: -19,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                      decoration: BoxDecoration(
                                          color: livraison.status?.color?.toColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      child: Text(livraison.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
                                    ),
                                  )
                                ],
                              ),
                            );
                        }
                    );
                  }
                  return SizedBox();
                },
              )
          )
        ],
      )
    );
  }

  void listener(BuildContext context, LivraisonsState state) {
  }

  void fetchData() {
    BlocProvider.of<LivraisonsBloc>(context).add(FetchData());
  }

  onLIvraisonClick(LivraisonEntity livraison, BuildContext context) {
    GoRouter.of(context).push("/livraison/${livraison.id}");
  }

  void onScann()async {
    var result=await GoRouter.of(context).push(Routes.scanner);
    print("====================result qr==============================${result}");
    if(result is String){
      print("===============excuted=====================");
      int? idLivraison=QrPayload.getIdLivraison(result.toString());
      if(idLivraison!=null){
        GoRouter.of(context).push("/livraison/${idLivraison}");
      }
    }
  }
}