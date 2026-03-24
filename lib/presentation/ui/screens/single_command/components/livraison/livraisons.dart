
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/add_command/add_command_bloc.dart';
import 'package:pda/presentation/blocs/single_command/single_command_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/form_field.dart';
import 'package:pda/presentation/ui/components/info_item.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/single_command/components/livraison/product_item.dart';
import 'package:toastification/toastification.dart';







class LivCommandScreen extends StatefulWidget {

  LivCommandScreen({Key? key}) : super(key: key);

  static Widget page(SingleCommandBloc bloc){
    return BlocProvider.value(
        value: bloc,
      child: LivCommandScreen(),
    );
  }

  @override
  State<LivCommandScreen> createState() => _LivCommandScreenState();
}

class _LivCommandScreenState extends State<LivCommandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Livraison",
      ),
      body: Column(
        children: [
          BlocListener<SingleCommandBloc,SingleCommandState>(
              listener: listener,
            child: SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<SingleCommandBloc,SingleCommandState>(
              builder: (context,state){

                List<CommandDetailEntity> details=state.unDelivredCommands;


                return Column(
                  children: [
                    const SizedBox(height: 15,),
                    Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                      child: MyFormField(
                          hint: "Entrer la date de livraison",
                          label: "Date livraison",
                          suffix: const Icon(Icons.date_range,color: AppColors.primaryColor,),
                          hintColor: Colors.grey,
                        onTap: selectDate,
                        onSuffixClick: selectDate,
                        borderColor: Colors.black,
                        activeBorderColor: Colors.black,
                        labelColor: Colors.black,
                        readOnly: true,
                        controller: TextEditingController()..text=state.dateLivraison!.formattedDateFr,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    MyCustomButton(
                        name: "Confirmer",
                      color: Colors.green,
                      isLoading:state.livraisonStatus==AppStatus.loading,
                      onClick: livrerCommand,
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
                                        itemCount:details.length,
                                        itemBuilder: (context,index){
                                          CommandDetailEntity detail=details.elementAt(index);
                                          return ProductItemLivraison(calculChanged: calculChanged, detail: detail);
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

  void listener(BuildContext context, SingleCommandState state) {
    if(state.livraisonStatus==AppStatus.error){
      if(state.isOffline??false){
        showToast("Error", context,description: AppStrings.checkConnectivity,type: ToastificationType.warning);
      }else{
        showToast("Error", context,description: AppStrings.tryAgain,type: ToastificationType.error);
      }
    }else if(state.livraisonStatus==AppStatus.success){
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

  void livrerCommand() {
    BlocProvider.of<SingleCommandBloc>(context).add(LivrerCommand());
  }

  void selectDate() async{
    DateTime? date=await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if(date!=null){
      BlocProvider.of<SingleCommandBloc>(context).add(SelectDate(date));
    }
  }
}
