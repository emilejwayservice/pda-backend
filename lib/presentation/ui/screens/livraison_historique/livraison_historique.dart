import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/presentation/blocs/livraison_historique/livraison_historique_bloc.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';
import 'package:pda/routes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums/app_status.dart';
import '../../../../domain/entities/Livraison.dart';
import '../../components/error_offline_widget.dart';
import '../../components/form_field.dart';
import '../../components/loading_widget.dart';
import '../../components/my_app_bar.dart';




class LivraisonHistoriqueScreen extends StatefulWidget {
  const LivraisonHistoriqueScreen({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<LivraisonHistoriqueBloc>(
        create: (context)=>LivraisonHistoriqueBloc(),
      child: LivraisonHistoriqueScreen(),
    );
  }

  @override
  State<LivraisonHistoriqueScreen> createState() => _LivraisonHistoriqueScreenState();
}

class _LivraisonHistoriqueScreenState extends State<LivraisonHistoriqueScreen> {



  late TextEditingController livraisonController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(DateTime.now());
    livraisonController=TextEditingController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "Historiques",
        ),
        body: Column(
          children: [
            BlocListener<LivraisonHistoriqueBloc,LivraisonHistoriqueState>(
              listener: listener,
              child: SizedBox(),
            ),
            Expanded(
                child: BlocBuilder<LivraisonHistoriqueBloc,LivraisonHistoriqueState>(
                  builder: (context,state){
                    if(state.fetchStatus==AppStatus.loading){
                      return const Center(child: LoadingWidget(),);
                    }else if(state.fetchStatus==AppStatus.error){
                      return OfflineErrodWidget(isOffline: state.isOffline??false,error: state.error,action:()=>fetchData(state.selectedDate!),);
                    }else if(state.fetchStatus==AppStatus.success){
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 12),
                            child: MyFormField(
                              hint: "Entrer la date de command",
                              label: "Date commade",
                              borderColor: Colors.black,
                              labelColor: Colors.black,
                              activeBorderColor: Colors.black,
                              hintColor: Colors.grey,
                              controller:livraisonController..text= state.selectedDate?.formattedDateFr??"",
                              readOnly: true,
                              onTap: selectDateCommand,
                              onSuffixClick: selectDateCommand,
                              suffix: const Icon(Icons.calendar_month_outlined,color: AppColors.primaryColor,),
                            ),
                          ),
                          Expanded(
                            child:(state.livraisons??[]).isEmpty
                                ?Center(child: NotFoundWidget())
                                :ListView.builder(
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
                                          subtitle: Text("${livraison.client?.nom}",style: GoogleFonts.aBeeZee(color:Colors.grey,fontWeight:FontWeight.w800),),
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
                            ),
                          ),
                        ],
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

  void listener(BuildContext context, LivraisonHistoriqueState state) {
  }

  onLIvraisonClick(LivraisonEntity livraison, BuildContext context) {
    GoRouter.of(context).push(Routes.livraisonDetails.replaceFirst(":id", livraison.id.toString()));
  }

  void fetchData(DateTime date) {
    BlocProvider.of<LivraisonHistoriqueBloc>(context).add(SelectedDate(date));
  }

  void selectDateCommand()async {
    DateTime? date=await showDatePicker(
        context: context,
        firstDate: DateTime.now().add(const Duration(days: -30)),
        lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly
    );
    if(date!=null){
      fetchData(date);
    }
  }
}