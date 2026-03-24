import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/presentation/blocs/client_details/client_detail_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/info_item.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/client_details/components/commands/command_list.dart';
import 'package:pda/presentation/ui/screens/client_details/components/factures/facture_list.dart';
import 'package:pda/presentation/ui/screens/client_details/components/livraisons/livraison_list.dart';

import '../../../../core/constants/app_images.dart';






class ClientDetailsScreen extends StatefulWidget {

  ClientDetailsScreen({Key? key}) : super(key: key);



  static Widget page(int idClient){
    return BlocProvider<ClientDetailBloc>(
        create: (context)=>ClientDetailBloc(idClient),
      child: ClientDetailsScreen(),
    );
  }


  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {

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
        action: IconButton(
          onPressed: onQrCodeClick,
          icon: const Icon(Icons.qr_code,color: Colors.white,),
        ),
      ),
      body: BlocBuilder<ClientDetailBloc,ClientDetailState>(
        builder: (context,state){
          if(state.fetchData==AppStatus.loading){
            return const Center(
              child: LoadingWidget(),
            );
          }else if(state.fetchData==AppStatus.error){
            if(state.isOffline??false){
              return OfflineWidget(
                  action: AppStrings.tryAgain,
                  msg: AppStrings.checkConnectivity,
                actionCLick: fetchData,
              );
            }else{
              return MyErrorWidget(
                  error: "Error",
                  action: AppStrings.tryAgain,
                actionCLick: fetchData,
              );
            }
          }else if(state.fetchData==AppStatus.success){
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  MyCustomButton(name: "Réglement",
                    iconWidget:const ImageIcon(AssetImage(AppImages.ic_money),color: Colors.white,),
                    color: Colors.green,
                    width: 240,
                    onClick: onReglementClick,
                  ),
                  const SizedBox(height: 10,),
                  InfoItem(
                    name: "Nom :",
                    value: state.client?.nom,
                  ),
                  InfoItem(
                    name: "Email :",
                    value: state.client?.email,
                  ),
                  InfoItem(
                    name: "Ville :",
                    value: state.client?.city,
                  ),
                  InfoItem(
                    name: "Tel :",
                    value: state.client?.tel,
                  ),
                  InfoItem(
                    name: "Activité :",
                    value: state.client?.activity,
                  ),
                  InfoItem(
                    name: "Type :",
                    value: state.client?.clientClass,
                  ),
                  InfoItem(
                    name: "Solde :",
                    value: state.client?.solde?.toString()??"-",
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                    child: ListTile(
                      onTap: ()=>onCommandsClick(state.client!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      tileColor: const Color(0xffFCDAB5),
                      title: Text("Commandes",style: GoogleFonts.aBeeZee(fontSize:18,fontWeight:FontWeight.bold,color:Colors.black),),
                      trailing:const Icon(Icons.arrow_forward_ios_sharp,color: Colors.black,)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                    child: ListTile(
                        onTap: ()=>onLivraisonClick(state.client!),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        tileColor: const Color(0xffFCDAB5),
                        title: Text("Livraisons",style: GoogleFonts.aBeeZee(fontSize:18,fontWeight:FontWeight.bold,color:Colors.black),),
                        trailing:const Icon(Icons.arrow_forward_ios_sharp,color: Colors.black,)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                    child: ListTile(
                      onTap: ()=>onFacturesClick(state.client!),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        tileColor: const Color(0xffFCDAB5),
                        title: Text("Factures",style: GoogleFonts.aBeeZee(fontSize:18,fontWeight:FontWeight.bold,color:Colors.black),),
                        trailing:const Icon(Icons.arrow_forward_ios_sharp,color: Colors.black,)
                    ),
                  )
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  void fetchData() {
    BlocProvider.of<ClientDetailBloc>(context).add(FetchData());
  }

  void onCommandsClick(ClientEntity client) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (cont){
              return BlocProvider.value(
                value: BlocProvider.of<ClientDetailBloc>(context),
                child: CommandList(),
              );
            }
        )
    );
  }

  void onLivraisonClick(ClientEntity client) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder:(cont){
              return BlocProvider.value(
                  value: BlocProvider.of<ClientDetailBloc>(context),
                child: LivraisonList(),
              );
            }
        )
    );
  }

  void onFacturesClick(ClientEntity client) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder:(cont){
              return BlocProvider.value(
                  value: BlocProvider.of<ClientDetailBloc>(context),
                child: FactureList(),
              );
            }
        )
    );
  }

  void onReglementClick() {
    int idClient = BlocProvider.of<ClientDetailBloc>(context).state.idClient!;
    GoRouter.of(context).push("/client-reglement/${idClient}");
  }

  void onQrCodeClick() {
    BlocProvider.of<ClientDetailBloc>(context).add(GenerateQrCode());
  }
}
