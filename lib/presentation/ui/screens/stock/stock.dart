import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/stock/stock_bloc.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';

import '../../../../domain/entities/entrepot.dart';


class StockScreen extends StatefulWidget {

  StockScreen({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<StockBloc>(
        create: (context)=>StockBloc(),
      child: StockScreen(),
    );
  }

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {


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
          title: "Entrepot",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              BlocListener<StockBloc,StockState>(
                  listener: listener,
                child: SizedBox(),
              ),
              Expanded(
                child: BlocBuilder<StockBloc, StockState>(
                  builder: (context, state) {
                    if(state.fetchDataStatus==AppStatus.loading){
                      return Center(
                        child: LoadingWidget(),
                      );
                    }else if(state.fetchDataStatus==AppStatus.error){
                      return OfflineErrodWidget(isOffline: state.isOffline??false,action: fetchData,error: state.error??"Error",);
                    }else if(state.fetchDataStatus==AppStatus.success){
                      return Column(
                        children: [
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: DropdownButton(
                                hint: Text(
                                  "Entrez l'entrepôt",
                                  style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey),
                                ),
                                menuMaxHeight: 400,
                                underline: null,
                                isExpanded: true,
                                value: state.selectedEntrepot,
                                items: List<
                                    DropdownMenuItem<EntrepotEntity>>.from(
                                    state.entrepots!.map((e) =>
                                        DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            "${e.libelle}",
                                            style: GoogleFonts.aBeeZee(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ))),
                                onChanged: onChanged),
                          ),
                          const SizedBox(height: 10,),
                          Expanded(
                              child:_products(state)
                          )
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  void fetchData() {
    BlocProvider.of<StockBloc>(context).add(FetchData());
  }


  void listener(BuildContext context, StockState state) {
  }

  void onChanged(EntrepotEntity? value) {
    if(value==null)return;
    BlocProvider.of<StockBloc>(context).add(FetchProducts(value));
  }

  Widget _products(StockState state) {
    if(state.fetchProductsStatus==AppStatus.error){
      return Center(child: OfflineErrodWidget(isOffline: state.isOffline??false,action:fetchProducts,error:state.error??"Error",));
    }else if(state.fetchProductsStatus==AppStatus.success && state.products!.isNotEmpty){
      return ListView.builder(
        itemCount: state.products?.length??0,
          itemBuilder: (context,index){
            ProductEntity product=state.products!.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                title: Text("${product.labelle}",style: GoogleFonts.aBeeZee(fontSize:17,fontWeight:FontWeight.bold,color:Colors.black),),
                subtitle: Text("reel:${product.reel}",style: GoogleFonts.aBeeZee(fontSize:17,color:Colors.grey[700]),),
                trailing: Text("${product.theorique}",style: GoogleFonts.aBeeZee(fontSize:17,color:Colors.black),),
              ),
            );
          }
      );
    }else if(state.fetchProductsStatus==AppStatus.loading){
      return const Center(
        child: LoadingWidget(),
      );
    }
    return NotFoundWidget();
  }

  void fetchProducts() {
    BlocProvider.of<StockBloc>(context).add(RefetchProducts());
  }
}