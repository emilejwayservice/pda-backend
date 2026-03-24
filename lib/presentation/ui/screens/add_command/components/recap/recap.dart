
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/add_command/add_command_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/info_item.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/add_command/components/recap/product_item.dart';
import 'package:toastification/toastification.dart';







class RecapScreen extends StatefulWidget {

  RecapScreen({Key? key}) : super(key: key);

  static Widget page(AddCommandBloc bloc){
    return BlocProvider.value(
        value: bloc,
      child: RecapScreen(),
    );
  }

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Résumer",
      ),
      body: Column(
        children: [
          BlocListener<AddCommandBloc,AddCommandState>(
              listener: listener,
            child: SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<AddCommandBloc,AddCommandState>(
              builder: (context,state){

                List<ProductEntity> products=state.getSelectedProducts();


                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          InfoItem(
                            name: "Total HT:",
                            value: state.totalHt.toString(),
                          ),
                          const SizedBox(height: 10,),
                          InfoItem(
                            name: "Total TTC:",
                            value: state.totalTTC.toString(),
                          ),
                        ],
                      ),
                    ),
                    MyCustomButton(
                        name: "Ajouter",
                      color: Colors.green,
                      isLoading:state.addCommandStatus==AppStatus.loading,
                      isDisabled: state.addCommandStatus==AppStatus.success,
                      onClick: addCommandClick,
                    ),
                    const SizedBox(height: 15,),
                    Expanded(
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 16),
                          padding :const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text("Articles",style:GoogleFonts.aBeeZee(color:AppColors.primaryColor,fontSize:18,fontWeight:FontWeight.bold) ,),
                                const SizedBox(height: 10,),
                                Expanded(
                                    child:ListView.builder(
                                        itemCount:products.length,
                                        itemBuilder: (context,index){
                                          ProductEntity product=products.elementAt(index);
                                          return ProductItem(calculChanged: calculChanged,tva: state.tvas??[], product: product);
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
              },
            ),
          ),
        ],
      ),
    );
  }

  void listener(BuildContext context, AddCommandState state) {
    if(state.addCommandStatus==AppStatus.error){
      if(state.isOffline??false){
        showToast("Error", context,description: AppStrings.checkConnectivity,type: ToastificationType.warning);
      }else{
        showToast("Error", context,description: AppStrings.tryAgain,type: ToastificationType.error);
      }
    }else if(state.addCommandStatus==AppStatus.success){
      showToast("Success", context,second: 2,isDismissable: false,whenComplete: (){
        Navigator.pop(context);
      });
    }
  }

  void calculChanged() {
    setState(() {

    });
  }

  void addCommandClick() {
    BlocProvider.of<AddCommandBloc>(context).add(AddCommand());
  }
}
