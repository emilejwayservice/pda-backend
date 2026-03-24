import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/core/validator/validator.dart';
import 'package:pda/domain/entities/activity_client.dart';
import 'package:pda/presentation/blocs/add_client/add_client_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/form_field.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:toastification/toastification.dart';

import '../../../../domain/entities/type_client.dart';




class AddClientScreen extends StatefulWidget {
  AddClientScreen({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<AddClientBloc>(
        create: (context)=>AddClientBloc(),
      child: AddClientScreen(),
    );
  }


  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {

  late TextEditingController nomController;
  late TextEditingController emailController;
  late TextEditingController adressController;
  late TextEditingController cityController;
  late TextEditingController phoneController;
  late GlobalKey<FormState> formState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    nomController=TextEditingController();
    emailController=TextEditingController();
    adressController=TextEditingController();
    cityController=TextEditingController();
    phoneController=TextEditingController();
    formState=GlobalKey<FormState>();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "ajouter un client",
      ),
      body: Column(
        children: [
          BlocListener<AddClientBloc,AddClientState>(
              listener: listener,
            child: SizedBox(),
          ),
          Expanded(
              child: BlocBuilder<AddClientBloc,AddClientState>(
                builder: (context,state){
                  if(state.fetchDataStatus==AppStatus.loading){
                    return const Center(
                      child:LoadingWidget() ,
                    );
                  }else if(state.fetchDataStatus==AppStatus.error){
                    if(state.isOffline??false){
                      return Center(
                        child: OfflineWidget(
                          msg: AppStrings.checkConnectivity,
                          action: AppStrings.tryAgain,
                          actionCLick: fetchData,
                        ),
                      );
                    }else{
                      return Center(
                        child: MyErrorWidget(
                          error: "Error",
                          action: AppStrings.tryAgain,
                          actionCLick: fetchData,
                        ),
                      );
                    }
                  }else if(state.fetchDataStatus==AppStatus.success){
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Form(
                          key: formState,
                          child: Column(
                            children: [
                              const SizedBox(height: 20,),
                              typeSelector(context, state),
                              const SizedBox(height: 20,),
                              activitySelector(context, state),
                              const SizedBox(height: 20,),
                              MyFormField(
                                  hint: "Entrer le nom du client",
                                  label: "Nom",
                                hintColor: Colors.grey,
                                activeBorderColor: Colors.black,
                                borderColor: Colors.black,
                                labelColor: Colors.black,
                                validator: Validator().required().make(),
                                controller: nomController,
                              ),
                              const SizedBox(height: 20,),
                              MyFormField(
                                hint: "Entrer l'email du client",
                                label: "Email",
                                hintColor: Colors.grey,
                                activeBorderColor: Colors.black,
                                borderColor: Colors.black,
                                labelColor: Colors.black,
                                validator: Validator().required().email().make(),
                                controller: emailController,
                              ),
                              const SizedBox(height: 20,),
                              MyFormField(
                                hint: "Entrer l'adresse du client",
                                label: "Adresse",
                                hintColor: Colors.grey,
                                activeBorderColor: Colors.black,
                                borderColor: Colors.black,
                                labelColor: Colors.black,
                                validator: Validator().required().make(),
                                controller: adressController,
                              ),
                              const SizedBox(height: 20,),
                              MyFormField(
                                hint: "entrer la ville du client",
                                label: "Ville",
                                hintColor: Colors.grey,
                                activeBorderColor: Colors.black,
                                borderColor: Colors.black,
                                labelColor: Colors.black,
                                validator: Validator().required().make(),
                                controller: cityController,
                              ),
                              const SizedBox(height: 20,),
                              MyFormField(
                                hint: "Entrer tel du client",
                                label: "Tel",
                                hintColor: Colors.grey,
                                activeBorderColor: Colors.black,
                                borderColor: Colors.black,
                                labelColor: Colors.black,
                                validator: Validator().required().min(9).make(),
                                controller: phoneController,
                                inputType: TextInputType.number,
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction(teleControl)
                                ],
                                leading: const SizedBox(
                                  width: 50,
                                  child: Center(child: Text("+212")),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              MyCustomButton(
                                  name: "Ajouter",
                                  onClick: ajouterClient,
                                isLoading: state.addClientStatus==AppStatus.loading,
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ),
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
  Widget typeSelector(BuildContext context,AddClientState state)=>Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButton(
        hint: Text(
          "Entrez le type de client",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: null,
        isExpanded: true,
        value: state.selectedType,
        items: List<DropdownMenuItem<TypeClientEntity>>.from(
            state.types!.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                "${e.libelle}",
                style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ))),
        onChanged: onSelectType),
  );
  Widget activitySelector(BuildContext context,AddClientState state)=>Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButton<ActivityClientEntity>(
        hint: Text(
          "Entrez l'activité de client",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: null,
        isExpanded: true,
        value: state.selectedActivity,
        items: List<DropdownMenuItem<ActivityClientEntity>>.from(
            state.activities!.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                "${e.label}",
                style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ))),
        onChanged: onSelectActivity),
  );

  void listener(BuildContext context, AddClientState state) {
    if(state.addClientStatus==AppStatus.error){
      showToast("", context,
          description:(state.isOffline??false)
              ?AppStrings.checkConnectivity
              :(state.error??"Error"),
        type: ToastificationType.warning
      );
    }else if(state.addClientStatus==AppStatus.success){
      showToast("Success", context,second: 3);
      clearInputes();
    }
  }

  void clearInputes(){
    phoneController.clear();
    nomController.clear();
    adressController.clear();
    cityController.clear();
    emailController.clear();
  }

  void fetchData() {
    BlocProvider.of<AddClientBloc>(context).add(FetchData());
  }

  void onSelectType(TypeClientEntity? value) {
    if(value!=null){
      BlocProvider.of<AddClientBloc>(context).add(SelectType(value));
    }
  }


  void onSelectActivity(ActivityClientEntity? value) {
    if(value!=null){
      BlocProvider.of<AddClientBloc>(context).add(SelectActivity(value));
    }
  }

  void ajouterClient() {
    AddClientState state = BlocProvider.of<AddClientBloc>(context).state;
    if(state.selectedType==null){
      showToast("", context,description: "Vous devez entrer le type de client",type: ToastificationType.warning);
      return;
    }
    if(state.selectedActivity==null){
      showToast("", context,description: "Vous devez entrer l'activité du client.",type: ToastificationType.warning);
      return;
    }
    if(formState.currentState!.validate()){
      BlocProvider.of<AddClientBloc>(context).add(
          AddClient(nomController.text,
              emailController.text,
              adressController.text,
              cityController.text,
              "212${phoneController.text}")
      );
    }

  }

  TextEditingValue teleControl(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty)return newValue;
    if(newValue.text.length>9){
      return oldValue;
    }
    return newValue;
  }
}
