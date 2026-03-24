import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/retour_details/retour_details_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/info_item.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';




class RetourDetailsScreen extends StatefulWidget {
  RetourDetailsScreen({Key? key}) : super(key: key);

  static Widget page(int id){
    return BlocProvider<RetourDetailsBloc>(
      create: (context) => RetourDetailsBloc(id),
      child: RetourDetailsScreen(),
    );
  }

  @override
  State<RetourDetailsScreen> createState() => _RetourDetailsScreenState();
}

class _RetourDetailsScreenState extends State<RetourDetailsScreen> {
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
      ),
      body: Column(
        children: [
          BlocListener<RetourDetailsBloc,RetourDetailsState>(
              listener: listener,
              child: SizedBox(),
          ),
          Expanded(
              child: BlocBuilder<RetourDetailsBloc,RetourDetailsState>(
                builder: (context,state){
                  if(state.fetchData==AppStatus.loading){
                    return const Center(
                      child: LoadingWidget(),
                    );
                  }else if(state.fetchData==AppStatus.error){
                    return OfflineErrodWidget(isOffline: state.isOffline??false,error: state.error??"Error",action: fetchData,);
                  }else if(state.fetchData==AppStatus.success){
                    return Column(
                      children: [
                        const SizedBox(height: 10,),
                        if(state.retour?.status?.id==1||state.retour?.status?.id==2)
                        MyCustomButton(name: " Livrer",
                          onClick: onLivrer,
                          icon: FontAwesomeIcons.truck,
                          color: Colors.lightBlue,
                          width: 200,
                          isLoading: state.livraisonStatus==AppStatus.loading,
                        ),
                        const SizedBox(height: 10,),
                        InfoItem(
                          name: "Date Retour",
                          value: state.retour?.dateRetour?.formattedDateFr,
                        ),
                        InfoItem(
                          name: "Entrepot",
                          value: state.retour?.entrepotE?.libelle,
                        ),
                        InfoItem(
                          name: "Client",
                          value: state.retour?.client?.nom,
                        ),
                        Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status",
                                style: GoogleFonts.acme(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                decoration: BoxDecoration(
                                    color: state.retour?.status?.color?.toColor,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Text(state.retour?.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Expanded(
                            child: Container(
                              margin:EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:const  BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Text("Products",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,fontSize:17,color:AppColors.primaryColor),),
                                    const SizedBox(height: 10,),
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: state.retour?.productsE?.length??0,
                                            itemBuilder: (context,index){
                                              ProductEntity prod=state.retour!.productsE!.elementAt(index);
                                              return Container(
                                                margin: const EdgeInsets.symmetric(vertical: 7),
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16),
                                                    color: Colors.white
                                                ),
                                                child: ListTile(
                                                  title: Text("${prod.labelle}",
                                                    style: GoogleFonts.aBeeZee(color:Colors.black,fontWeight:FontWeight.bold),),
                                                  trailing: Text("${prod.quantity}",style: GoogleFonts.aBeeZee(fontSize:17,color:Colors.grey,fontWeight:FontWeight.bold),),
                                                ),
                                              );
                                            }
                                        )
                                    )
                                  ],
                                ),
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

  void fetchData() {
    BlocProvider.of<RetourDetailsBloc>(context).add(FetchData());
  }

  void listener(BuildContext context, RetourDetailsState state) {

  }

  void onLivrer() {
    BlocProvider.of<RetourDetailsBloc>(context).add(Livrer());

  }
}
