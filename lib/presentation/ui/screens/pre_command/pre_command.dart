import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/constants/products_images.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/pre_command/pre_command_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/pre_command/components/product_item_img.dart';
import 'package:pda/presentation/ui/screens/pre_command/components/recap/recap.dart';
import '../../../../domain/entities/client.dart';



class PreCommand extends StatefulWidget {
  const PreCommand({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<PreCommandBloc>(
        create: (conext)=>PreCommandBloc(),
      child: PreCommand(),
    );
  }

  @override
  State<PreCommand> createState() => _PreCommandState();
}

class _PreCommandState extends State<PreCommand> {

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
        title: "pre command",
        action:BlocBuilder<PreCommandBloc,PreCommandState>(
          builder: (context,state){
            return IconButton(
                onPressed: onCartClick,
                icon: Badge(
                  label: Text("${state.countProdNotSent??0}"),
                  child: Icon(Icons.shopping_cart),
                )
            );
          },
        )
      ),
      body: BlocBuilder<PreCommandBloc,PreCommandState>(
        builder: (context,state){
          if(state.fetchData==AppStatus.loading){
            return const Center(child: LoadingWidget(),);
          }else if(state.fetchData==AppStatus.error){
            return OfflineErrodWidget(isOffline: state.isOffline??false,action: fetchData,error: state.error,);
          }
          else if(state.fetchData==AppStatus.success){
            return Container(
              margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius:const  BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: DropdownButton(
                          hint: Text(
                            "Entrez le client",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w700, color: Colors.grey),
                          ),
                          menuMaxHeight: 400,
                          underline: null,
                          isExpanded: true,
                          value: state.selectedClient,
                          items: List<DropdownMenuItem<ClientEntity>>.from(
                              state.clients!.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  "${e.nom}",
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ))),
                          onChanged: onChanged),
                    ),
                    const SizedBox(height: 16,),
                    Expanded(
                        child: _products(state)
                    ),
                    const SizedBox(height: 10,),
                    MyCustomButton(name: "Ajouter",onClick: ajouter,color: Colors.green,),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            );
          }
          return SizedBox();

        },
      ),
    );
  }

  void onCartClick() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (cnt)=>Recap.page(BlocProvider.of<PreCommandBloc>(context)))
    );
  }

  void onChanged(value) {
    BlocProvider.of<PreCommandBloc>(context).add(SelectClient(value));
  }

  void fetchData() {
    BlocProvider.of<PreCommandBloc>(context).add(FetchData());
  }

  Widget _products(PreCommandState state) {
    if(state.fetchProductsStatus==AppStatus.loading){
      return const Center(child: LoadingWidget(),);
    }else if(state.fetchProductsStatus==AppStatus.success){
      return GridView.builder(
        itemCount: state.products?.length??0,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 7,
            crossAxisSpacing: 7
          ),
          itemBuilder:  (context,index){
            ProductEntity product=state.products!.elementAt(index);
            product.image_path=product_images.elementAt(index);
            return MyGridTile(product:product );
          }
      );
    }
    return SizedBox();
  }

  void ajouter() {
    BlocProvider.of<PreCommandBloc>(context).add(AddProducts());
  }
}






