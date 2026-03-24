import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_images.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/core/validator/validator.dart';
import 'package:pda/domain/entities/bank.dart';
import 'package:pda/domain/entities/caisse.dart';
import 'package:pda/domain/entities/facture.dart';
import 'package:pda/domain/entities/payment_mode.dart';
import 'package:pda/presentation/blocs/client_reglement_bloc/client_reglement_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';
import 'package:pda/presentation/ui/screens/client_reglement/conponents/fcture_item.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/app_colors.dart';
import '../../components/form_field.dart';






class ClientReglementScreen extends StatefulWidget {
  ClientReglementScreen({Key? key}) : super(key: key);

  static Widget page(int id){
    return BlocProvider<ClientReglementBloc>(
        create: (context)=>ClientReglementBloc(id),
      child: ClientReglementScreen(),
    );
  }

  @override
  State<ClientReglementScreen> createState() => _ClientReglementScreenState();
}

class _ClientReglementScreenState extends State<ClientReglementScreen> {

  late TextEditingController dateControllerReglement;
  late TextEditingController dateControllerEcheance;

  late TextEditingController numeroController;
  late TextEditingController montantController;
  late GlobalKey<FormState> formState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    dateControllerReglement=TextEditingController();
    dateControllerEcheance=TextEditingController();
    numeroController=TextEditingController();
    montantController=TextEditingController();
    formState=GlobalKey<FormState>();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: "Réglement",
      ),
      body: BlocBuilder<ClientReglementBloc,ClientReglementState>(
        builder: (context,state){
          if(state.fetchData==AppStatus.loading){
            return const Center(
              child: LoadingWidget(),
            );
          }else if(state.fetchData==AppStatus.error){
            return Center(child: OfflineErrodWidget(isOffline: state.isOffline??false,error: state.error??"Error",action: fetchData,));
          }else if(state.fetchData==AppStatus.success){
            if(state.factures?.isEmpty??true){
              return NotFoundWidget(message: "Aucune facture",);
            }
            return Column(
              children: [
                Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Form(
                          key: formState,
                          child: Column(
                            children: [
                              BlocListener<ClientReglementBloc,ClientReglementState>(
                                listener: listener,
                                child: SizedBox(),
                              ),
                              const SizedBox(height: 10,),
                              MyFormField(
                                hint: "Entrer la date de réglement",
                                label: "Date réglement",
                                borderColor: Colors.black,
                                labelColor: Colors.black,
                                activeBorderColor: Colors.black,
                                hintColor: Colors.grey,
                                controller:dateControllerReglement..text= state.selectedDateReglement!.formattedDateFr,
                                readOnly: true,
                                onTap: selectDateReglement,
                                onSuffixClick: selectDateReglement,
                                suffix: const Icon(Icons.calendar_month_outlined,color: AppColors.primaryColor,),
                              ),
                              const SizedBox(height: 10,),
                              if(state.selectedMode?.reference=="cheque" || state.selectedMode?.reference=="traite")
                                MyFormField(
                                  hint: "Entrer la date d'echeance ",
                                  label: "Date echeance",
                                  borderColor: Colors.black,
                                  labelColor: Colors.black,
                                  activeBorderColor: Colors.black,
                                  hintColor: Colors.grey,
                                  controller:dateControllerEcheance..text= state.selectedDateEcheance!.formattedDateFr,
                                  readOnly: true,
                                  onTap: selectDateEcheance,
                                  onSuffixClick: selectDateEcheance,
                                  suffix: const Icon(Icons.calendar_month_outlined,color: AppColors.primaryColor,),
                                ),
                              const SizedBox(height: 10,),
                              MyFormField(
                                hint: "Entrer le numero",
                                label: "Numero",
                                borderColor: Colors.black,
                                activeBorderColor: Colors.black,
                                hintColor: Colors.grey,
                                labelColor: Colors.black,
                                controller: numeroController,
                                validator: Validator().required().make(),
                              ),
                              const SizedBox(height: 10,),
                              MyFormField(
                                hint: "Entrer le montant",
                                label: "Montant",
                                borderColor: Colors.black,
                                activeBorderColor: Colors.black,
                                hintColor: Colors.grey,
                                labelColor: Colors.black,
                                validator: Validator().required().make(),
                                controller: montantController,
                                inputType: TextInputType.number,
                                onChange: onChange,
                                formatters: [
                                  TextInputFormatter.withFunction(filterMontant)
                                ],
                              ),
                              const SizedBox(height: 20,),
                              modeSelector(state),
                              const SizedBox(height: 10,),
                              if(state.selectedMode?.reference=="virement" || state.selectedMode?.reference=="versement")
                                bankSelector(state),
                              const SizedBox(height: 10,),
                              if(state.selectedMode?.reference=="espece")
                                caisseSelector(state),
                              const SizedBox(height: 10,),
                              MyCustomButton(
                                name: "Valider",
                                color:Colors.green,
                                onClick: validerReglement,
                                isLoading: state.validerReglementStatus==AppStatus.loading,
                                iconWidget: const ImageIcon(AssetImage(AppImages.ic_money),color: Colors.white,),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                Expanded(
                    flex: 4,
                    child:Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(0,-2),blurRadius: 10)],
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text("Factures",style: GoogleFonts.aBeeZee(color:AppColors.primaryColor,fontSize:18,fontWeight:FontWeight.bold),),
                            const SizedBox(height: 10,),
                            Expanded(
                                child:ListView.builder(
                                  itemCount: state.factures?.length??0,
                                    itemBuilder: (context,index){
                                        FactureEntity facture=state.factures!.elementAt(index);
                                        return FactureItem(facture: facture);
                                    }
                                )
                            )
                          ],
                        ),
                      ),
                    )
                ),
              ],
            );
          }
          return SizedBox();
        },
      )
    );
  }
  Widget modeSelector(ClientReglementState state)=>Container(
    padding:const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButton(
        hint: Text(
          "Entrez le mode de peiment",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: null,
        isExpanded: true,
        value: state.selectedMode,
        items: List<DropdownMenuItem<PaymentModeEntity>>.from(
            state.payments!.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                "${e.libelle}",
                style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ))),
        onChanged: onModeChanged),
  );
  Widget bankSelector(ClientReglementState state)=>Container(
    padding:const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButton(
        hint: Text(
          "Entrez la banque",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: null,
        isExpanded: true,
        value: state.selectedBank,
        items: List<DropdownMenuItem<BankEntity>>.from(
            state.banks!.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                "${e.banque},${e.agence}",
                style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ))),
        onChanged: onBankChanged),
  );
  Widget caisseSelector(ClientReglementState state)=>Container(
    padding:const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButton(
        hint: Text(
          "Entrez la caisse",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: null,
        isExpanded: true,
        value: state.selectedCaisse,
        items: List<DropdownMenuItem<CaisseEntity>>.from(
            state.caisses!.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                "${e.libelle}",
                style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ))),
        onChanged: onCaisseChanged),
  );

  void fetchData() {
    BlocProvider.of<ClientReglementBloc>(context).add(FetchData());
  }

  void listener(BuildContext context, ClientReglementState state) {
    if(state.validerReglementStatus==AppStatus.success){
      showToast("Success", context,isDismissable: false,second: 2,whenComplete: (){
        Navigator.pop(context);
      });
    }else if(state.validerReglementStatus==AppStatus.error){
      if(state.isOffline??false){
        showToast("", context,description: AppStrings.checkConnectivity,type: ToastificationType.warning);
      }else{
        showToast("Error", context,description: state.error??AppStrings.tryAgain,type: ToastificationType.error);
      }
    }else if(state.validerReglementStatus==AppStatus.warning){
      showToast("", context,description: state.error??AppStrings.tryAgain,type: ToastificationType.warning);
    }
  }

  void selectDateReglement() async{
    DateTime? date=await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if(date!=null){
      BlocProvider.of<ClientReglementBloc>(context).add(SelectDateReglement(date));
    }
  }

  void selectDateEcheance() async{
    DateTime? date=await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if(date!=null){
      BlocProvider.of<ClientReglementBloc>(context).add(SelectDateEcheance(date));
    }
  }

  void onModeChanged(PaymentModeEntity? value) {
    if(value==null)return;
    BlocProvider.of<ClientReglementBloc>(context).add(SelectMode(value));
  }



  void onBankChanged(BankEntity? value) {
    if(value==null)return;
    BlocProvider.of<ClientReglementBloc>(context).add(SelectBank(value));
  }

  void onCaisseChanged(CaisseEntity? value) {
    if(value==null)return;
    BlocProvider.of<ClientReglementBloc>(context).add(SelectCaisse(value));
  }

  TextEditingValue filterMontant(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty){
      return newValue;
    }
    RegExp regExp=RegExp(r"^\d+\.?\d*$");
    if(!regExp.hasMatch(newValue.text)){
      return oldValue;
    }
    ClientReglementState state=BlocProvider.of<ClientReglementBloc>(context).state;
    double montant=double.parse(newValue.text);
    print("=====================${montant>(state.totalFactures??0)}");
    print("=====================${state.totalFactures}");
    if((state.totalFactures??0)<montant){
      return oldValue;
    }
    return newValue;
  }

  void onChange(String value) {
    BlocProvider.of<ClientReglementBloc>(context).add(CalculMontant(value));
  }

  void validerReglement() {
    if(formState.currentState!.validate()){
      BlocProvider.of<ClientReglementBloc>(context).add(ValiderReglement(numeroController.text, montantController.text));
    }
  }
}







