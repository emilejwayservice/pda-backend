import 'dart:ui';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/utils/show_dialogue_infos.dart';
import 'package:pda/core/utils/show_progress_dialogue.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/core/validator/validator.dart';
import 'package:pda/domain/entities/company.dart';
import 'package:pda/presentation/blocs/login/login_bloc.dart';
import 'package:pda/presentation/ui/screens/auth/components/logo.dart';
import 'package:toastification/toastification.dart';


import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../routes.dart';
import '../../../components/custom_button.dart';
import '../../../components/form_field.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);


  static Widget page(){
    return BlocProvider<LoginBloc>(
      create:(ctx)=> LoginBloc(),
      child: LoginScreen(),
    );
  }


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController companyController;
  late GlobalKey<FormState> formState;

  int? selectedCompany;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController=TextEditingController();
    passwordController=TextEditingController();
    companyController=TextEditingController();
    formState=GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              BlocListener<LoginBloc,LoginState>(
                  listener: listener,
                child: SizedBox(),
              ),
              const LogoWidget(),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextAnimator(
                      "Connexion",
                      style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:35,fontWeight:FontWeight.bold),
                      atRestEffect: WidgetRestingEffects(duration: const Duration(seconds: 2),style: WidgetRestingEffectStyle.none),
                    ),
                    TextAnimator(
                      "Veuillez vous connecter pour continuer.",
                      style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:20,fontWeight:FontWeight.normal),
                      atRestEffect: WidgetRestingEffects(duration: const Duration(seconds: 2),style: WidgetRestingEffectStyle.none),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                width: width,
                constraints: const BoxConstraints(
                  maxWidth: 400
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                decoration:BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(3,3),blurRadius: 20)],
                  borderRadius: BorderRadius.circular(15)
                ),
                child:Form(
                  key: formState,
                  child: Column(
                    children: [
                      MyFormField(
                        label: "Email",
                        hint: 'Entrez votre adresse e-mail',
                        borderColor: Colors.black,
                        activeBorderColor: Colors.black,
                        controller: emailController,
                        labelColor: Colors.black,
                        hintColor: Colors.grey,
                        validator: Validator().required().make(),
                      ),
                      const SizedBox(height: 20,),
                      MyFormField(
                        label: "Mot de passe",
                        hint: 'Entrez votre mot de passe',
                        borderColor: Colors.black,
                        labelColor: Colors.black,
                        activeBorderColor: Colors.black,
                        hintColor: Colors.grey,
                        openEyeIcon:  const Icon(Icons.remove_red_eye_outlined,color: Colors.black,),
                        closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: Colors.black,),
                        isPassWord: true,
                        controller: passwordController,
                        validator:Validator().required().make()
                      ),
                      const SizedBox(height: 20,),
                      MyFormField(
                          hint: "Choisissez votre société",
                          label: "Societe",
                          readOnly: true,
                        borderColor: Colors.black,
                        labelColor: Colors.black,
                        activeBorderColor: Colors.black,
                        hintColor: Colors.grey,
                        onTap: onSelectSociete,
                        controller: companyController,
                        validator:Validator().required().make()
                      ),
                      const SizedBox(height: 30,),
                      MyCustomButton(name: "Login",onClick: onLogin,),
                      //MyTextButton(parts: const ["don't have an account?"," Register"], colors: const [Colors.black,AppColors.primaryColor],onclick: registerCLick,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    GoRouter.of(context).replace(Routes.register);
  }

  void forgetPassClick() {
    GoRouter.of(context).replace(Routes.resetPassword);
  }

  void registerCLick() {
    GoRouter.of(context).replace(Routes.register);
  }

  void onSelectSociete() {
    DropDownState(
      DropDown(
        bottomSheetTitle:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Societies",
              style: GoogleFonts.aBeeZee(
                color:AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              "Choisir votre societe",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
        selectedItems: (list){
          if(list.isNotEmpty){
            companyController.text=list.first.name;
            selectedCompany=int.parse(list.first.value!);
          }
        },
        data: Dependencies.get<List<CompanyEntity>>().map(
                (e) => SelectedListItem(value: e.id.toString(),name: e.name??"")
        ).toList(),
        dropDownBackgroundColor: Colors.white,
        isSearchVisible: false,

        listItemBuilder: (index){
          CompanyEntity company=Dependencies.get<List<CompanyEntity>>().elementAt(index);
          return Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(10),
             color: Colors.grey[100]
           ),
            child:  ListTile(
              title: Text(company.name!,style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color:Colors.black),),
              subtitle:company.city!=null
                  ? Text("${company.city}",style: GoogleFonts.poppins(fontWeight:FontWeight.w400,color:Colors.grey),)
                  :null,
            ),
          );
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void onLogin() {
    if(!formState.currentState!.validate()){
      return;
    }
    BlocProvider.of<LoginBloc>(context).add(Login(selectedCompany!,emailController.text, passwordController.text));
  }

  void listener(BuildContext context, LoginState state) {
    if(state.loginStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.loginStatus==AppStatus.success){
      hideDialogue(context);
      showToast("Succès", context,isDismissable: false,second: 2,whenComplete: (){
        print("complete toast");
        GoRouter.of(context).replace(Routes.home);
      });
    }else if(state.loginStatus==AppStatus.error){
      hideDialogue(context);
      if(state.isOffline??false){
        showToast("Connectivity", context,description: AppStrings.checkConnectivity,type: ToastificationType.warning);
      }else {
        showToast("Error",description: state.error??"", context,type: ToastificationType.error);
      }
    }
  }
}
