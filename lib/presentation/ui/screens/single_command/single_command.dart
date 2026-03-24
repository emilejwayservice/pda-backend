import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/core/utils/show_dialogue_question.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/presentation/blocs/single_command/single_command_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/single_command/components/livraison/livraisons.dart';

import '../../../../domain/entities/command_details.dart';
import '../../components/info_item.dart';
import '../../components/my_app_bar.dart';





class SingleCommandScreen extends StatefulWidget {
  SingleCommandScreen();


  static Widget page(int command){
    return BlocProvider<SingleCommandBloc>(
        create: (context)=>SingleCommandBloc(command),
      child: SingleCommandScreen(),
    );
  }

  @override
  State<SingleCommandScreen> createState() => _SingleCommandScreenState();
}

class _SingleCommandScreenState extends State<SingleCommandScreen> {

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
        title: "Command details",
    ),
    body:Column(
      children: [
        BlocListener<SingleCommandBloc,SingleCommandState>(
            listener: listener,
          child: SizedBox(),
        ),
        Expanded(
          child: BlocBuilder<SingleCommandBloc,SingleCommandState>(
              builder: (context,state){
                if(state.fetchDataStatus==AppStatus.loading){
                  return Center(child: LoadingWidget(),);
                }else if(state.fetchDataStatus==AppStatus.error){
                  if(state.isOffline??false){
                    return Center(child: OfflineWidget(action: AppStrings.tryAgain, msg: AppStrings.checkConnectivity,actionCLick: fetchData,),);
                  }else{
                    return MyErrorWidget(error: "Error", action: AppStrings.tryAgain,actionCLick: fetchData,);
                  }
                }else if(state.fetchDataStatus==AppStatus.success){
                  CommandEntity command=state.command!;
                  return Column(
                    children: [
                      const SizedBox(height: 10,),
                      if(command.status?.id==1)
                      MyCustomButton(name: "Valider",
                        onClick: onValider,
                        icon: Icons.check,
                        color: Colors.green,
                        width: 200,
                        isDisabled: state.validerStatus==AppStatus.success,
                        isLoading: state.validerStatus==AppStatus.loading,
                      ),
                      if(command.status?.id==2 || command.status?.id==4)
                        MyCustomButton(name: " Livrer",
                          onClick: onLivrer,
                          icon: FontAwesomeIcons.truck,
                          color: Colors.lightBlue,
                          width: 200,
                        ),
                      const SizedBox(height: 10,),
                      InfoItem(
                        name: "Date Command",
                        value: command.dateCommand?.formattedDateFr,
                      ),
                      InfoItem(
                        name: "total HT",
                        value: command.totalHt?.toString()??"-",
                      ),
                      InfoItem(
                        name: "total TTC",
                        value: command.totalTTC?.toString()??"-",
                      ),
                      InfoItem(
                        name: "total TVA",
                        value: command.totalTva?.toString()??"-",
                      ),
                      InfoItem(
                        name: "Client",
                        value: command.client?.nom,
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
                                  color: command.status?.color?.toColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              child: Text(command.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
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
                                        itemCount: command.details?.length??0,
                                        itemBuilder: (context,index){
                                          CommandDetailEntity detail=command.details!.elementAt(index);
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
                                                  value: detail.product?.labelle,
                                                ),
                                                InfoItem(
                                                  name: "Prix",
                                                  value: detail.price?.toString()??"-",
                                                ),
                                                InfoItem(
                                                  name: "Quantité",
                                                  value: detail.quantity?.toString()??"-",
                                                ),
                                                InfoItem(
                                                  name: "Quantité restante",
                                                  value: detail.qtyRestante?.toString()??"-",
                                                ),
                                                InfoItem(
                                                  name: "Total HT",
                                                  value: detail.totalHt?.toString()??"-",
                                                ),
                                                InfoItem(
                                                  name: "Total TTC",
                                                  value: detail.totalTTC?.toString()??"-",
                                                ),
                                                InfoItem(
                                                  name: "Total TVA",
                                                  value: detail.totalTva?.toString()??"-",
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
              }
            ),
        ),
      ],
    )
    );



  }

  void fetchData() {
    BlocProvider.of<SingleCommandBloc>(context).add(FetchData());
  }

  void onValider() async{
    var result=await showDialogueQuestion(context, 'Voulez-vous valider cette commande','Oui','Non');
    if(result!=null && result){
      BlocProvider.of<SingleCommandBloc>(context).add(Valider());
    }
  }

  void listener(BuildContext context, SingleCommandState state) {
    if(state.validerStatus==AppStatus.success){
      showToast("Success", context);
    }
  }

  void onLivrer() {
    SingleCommandBloc bloc=BlocProvider.of<SingleCommandBloc>(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=>LivCommandScreen.page(bloc))
    );
  }
}
