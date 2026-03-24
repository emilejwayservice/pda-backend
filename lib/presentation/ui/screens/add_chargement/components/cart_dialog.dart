import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:toastification/toastification.dart';

import '../../../../blocs/add_chargement/add_chargement_bloc.dart';





class CartDialog extends StatefulWidget {


   CartDialog() ;


   static Widget page(AddChargementBloc bloc){
     return BlocProvider.value(
         value: bloc,
       child: CartDialog(),
     );
   }

  @override
  State<CartDialog> createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.sizeOf(context).height;
    double width=MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        width:width*0.9,
        height: height*0.7,
        constraints: const BoxConstraints(
          maxWidth: 400
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            BlocListener<AddChargementBloc,AddChargementState>(
                listener: listener,
              child: SizedBox(),
            ),
            Expanded(
              child: BlocBuilder<AddChargementBloc,AddChargementState>(
                builder: (context,state){
                  List<ProductEntity> selectedProds=state.getSelectedProducts();
                  return Material(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Products",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color:AppColors.primaryColor,fontSize:18),),
                            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.cancel_outlined,color:AppColors.primaryColor))
                          ],
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: selectedProds.length,
                                itemBuilder: (context,index){
                                  ProductEntity prod=selectedProds.elementAt(index);
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      tileColor: Colors.grey[100],
                                      title: Text("${prod.labelle}",style:GoogleFonts.aBeeZee(fontSize:16,color:Colors.black) ,),
                                      trailing: Text("${prod.quantity}",style: GoogleFonts.aBeeZee(color:AppColors.primaryColor,fontWeight:FontWeight.w700),),
                                    ),
                                  );
                                }
                            )
                        ),
                        const SizedBox(height: 10,),
                        MyCustomButton(
                            name: "Valider",
                            onClick: valider,
                            isLoading: state.addChargementStatus==AppStatus.loading,
                            color:Colors.green)
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }



  void listener(BuildContext context, AddChargementState state) {
    if(state.addChargementStatus==AppStatus.error){
      if(state.isOffline??false){
        showToast("Error", context,description: AppStrings.checkConnectivity,type: ToastificationType.error);
      }else{
        showToast("Error", context,description: AppStrings.tryAgain,type: ToastificationType.error);
      }
    }else if(state.addChargementStatus==AppStatus.success){
        Navigator.pop(context,true);
    }
  }

  void valider() {
    BlocProvider.of<AddChargementBloc>(context).add(AddChargement());
  }
}
