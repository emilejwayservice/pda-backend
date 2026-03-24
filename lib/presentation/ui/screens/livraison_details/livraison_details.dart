import 'dart:io';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_images.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/core/services/bleutooth_service.dart';
import 'package:pda/core/utils/show_dialogue_infos.dart';
import 'package:pda/core/utils/show_dialogue_question.dart';
import 'package:pda/core/utils/show_progress_dialogue.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/presentation/blocs/livraison_details/livraison_details_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/livraison_details/components/bluetooth_dialogue.dart';
import 'package:toastification/toastification.dart';

import '../../../../domain/entities/details.dart';
import '../../components/info_item.dart';







class LivraisonDetailsScreen extends StatefulWidget {
  LivraisonDetailsScreen({Key? key}) : super(key: key);


  static Widget page(int livraison){
    return BlocProvider<LivraisonDetailsBloc>(
        create: (ctx)=>LivraisonDetailsBloc(livraison),
       child: LivraisonDetailsScreen(),
    );
  }

  @override
  State<LivraisonDetailsScreen> createState() => _LivraisonDetailsScreenState();
}

class _LivraisonDetailsScreenState extends State<LivraisonDetailsScreen> {


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
        title: "Details",
        action: PopupMenuButton<String>(
          color: Colors.white,
          constraints: const BoxConstraints(
            minWidth: 170
          ),
          onSelected: onSelected,
          itemBuilder: (context)=>[
            PopupMenuItem(
              value: "recu",
                child: Row(
                  children: [
                    const ImageIcon(AssetImage(AppImages.ic_recu),color: AppColors.primaryColor,),
                    const SizedBox(width: 5,),
                    Text("Recu",style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:17),)
                  ],
                )
            ),
            PopupMenuItem(
                value: "bl",
                child: Row(
                  children: [
                    const ImageIcon(AssetImage(AppImages.ic_invoice),color: AppColors.primaryColor,),
                    const SizedBox(width: 5,),
                    Text("Bon Livraison",style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:17),)
                  ],
                )
            )
          ],
        ) ,
      ),
      body: Column(
        children: [
          BlocListener<LivraisonDetailsBloc,LivraisonDetailsState>(
              listener: listener,
            child: SizedBox(),
          ),
          Expanded(
              child: BlocBuilder<LivraisonDetailsBloc,LivraisonDetailsState>(
                builder: (context,state){
                  if(state.fetchData==AppStatus.loading){
                    return const Center(
                      child: LoadingWidget(),
                    );
                  }else if(state.fetchData==AppStatus.error){
                    return OfflineErrodWidget(isOffline: state.isOffline??false,action: fetchData,error: state.error??"Error",);
                  }else if(state.fetchData==AppStatus.success){
                    LivraisonEntity livraison=state.livraison!;
                    return  Column(
                      children: [
                        const SizedBox(height: 10,),
                        if(livraison.status?.id==1)
                        MyCustomButton(
                          name: "Valider",
                          icon: Icons.check,
                          color: Colors.green,
                          width: 200,
                          onClick: validerLivraison,
                          isLoading: state.validerLivraisonStatus==AppStatus.loading,
                        ),
                        if(livraison.status?.id==2)
                          MyCustomButton(
                            name: "Rendre facturable",
                            icon: Icons.insert_drive_file_sharp,
                            color: Colors.lightBlueAccent,
                            width: 200,
                            onClick:facturable ,
                            isLoading: state.validerLivraisonStatus==AppStatus.loading,
                          ),
                        const SizedBox(height: 10,),
                        InfoItem(
                          name: "Date livraison",
                          value: livraison.dateLaivraison?.formattedDateFr,
                        ),
                        InfoItem(
                          name: "total HT",
                          value: livraison.totalHt?.toString()??"-",
                        ),
                        InfoItem(
                          name: "total TTC",
                          value: livraison.totalTTC?.toString()??"-",
                        ),
                        InfoItem(
                          name: "total TVA",
                          value: livraison.totalTva?.toString()??"-",
                        ),
                        InfoItem(
                          name: "Client",
                          value: livraison.client?.nom,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Statut",
                                style: GoogleFonts.acme(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                decoration: BoxDecoration(
                                    color: livraison.status?.color?.toColor,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Text(livraison.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Expanded(
                            child:Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15,),
                                  Text("Details",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color:Colors.black,fontSize:18),),
                                  const SizedBox(height: 15,),
                                  Expanded(
                                    child: Padding(
                                      padding:const EdgeInsets.symmetric(horizontal: 15),
                                      child: ListView.builder(
                                          itemCount: livraison.details?.length??0,
                                          itemBuilder: (context,index){
                                            LivraisonDetailEntity livraisonDetail=livraison.details!.elementAt(index);
                                            return Container(
                                              margin: const EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8)
                                              ),
                                              child: Column(
                                                children: [
                                                  InfoItem(
                                                    name: "Article",
                                                    value: livraisonDetail.product?.labelle,
                                                  ),
                                                  InfoItem(
                                                    name: "Prix",
                                                    value: livraisonDetail.price?.toString()??"-",
                                                  ),
                                                  InfoItem(
                                                    name: "Quantité",
                                                    value: livraisonDetail.quantity?.toString()??"-",
                                                  ),
                                                  InfoItem(
                                                    name: "Total HT",
                                                    value: livraisonDetail.totalHt?.toString()??"-",
                                                  ),
                                                  InfoItem(
                                                    name: "Total TTC",
                                                    value: livraisonDetail.totalTTC?.toString()??"-",
                                                  ),
                                                  InfoItem(
                                                    name: "Total TVA",
                                                    value: livraisonDetail.totalTva?.toString()??"-",
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    );
                  }
                  return SizedBox();
                },
              )
          )
        ],
      ),
    );
  }





  void listener(BuildContext context, LivraisonDetailsState state) async{
    if(state.validerLivraisonStatus==AppStatus.error){
      if(state.isOffline??false){
        showToast("", context,description: AppStrings.checkConnectivity,type: ToastificationType.warning,second: 3);
      }else{
        showToast("Error",type: ToastificationType.error,second: 3, context,);
      }
    }else if(state.validerLivraisonStatus==AppStatus.success){
      showToast("Success", context);
    }
    //=================================================================================================================
    if(state.generatePdfStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.generatePdfStatus==AppStatus.success){
      hideDialogue(context);
    }else if(state.generatePdfStatus==AppStatus.error){
      hideDialogue(context);
    }

    //=================================================================================================================


    if(state.bluetoothSrviceReadyStatus==AppStatus.success){
       var result=await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx){
        return BluetoothDialogue.page(BlocProvider.of<LivraisonDetailsBloc>(context));
      }
    );
       if(result!=null){
         BlocProvider.of<LivraisonDetailsBloc>(context).add(SelectDevice(result as BluetoothDevice));
       }

    }




  }

  void fetchData() {
    BlocProvider.of<LivraisonDetailsBloc>(context).add(FetchData());
  }

  void validerLivraison()async {
    var result=await showDialogueQuestion(context, "Voulez-vous valider cette livraison ?","Oui","Non");
    if(result!=null && result){
      BlocProvider.of<LivraisonDetailsBloc>(context).add(ValiderLivraison());
    }
  }

  void onSelected(String value) async{
    if(value=="recu"){
      BlocProvider.of<LivraisonDetailsBloc>(context).add(GenerateRecu());
    }else{
      BlocProvider.of<LivraisonDetailsBloc>(context).add(GenerateBl());
    }
  }




  void facturable() {
    BlocProvider.of<LivraisonDetailsBloc>(context).add(FacturableLivraison());
  }
}
