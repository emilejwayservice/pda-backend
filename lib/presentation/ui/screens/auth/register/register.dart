import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../routes.dart';
import '../../../components/custom_button.dart';
import '../../../components/form_field.dart';
import '../../../components/text_button.dart';
import '../components/logo.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController=TextEditingController();
    passwordController=TextEditingController();
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
              LogoWidget(),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextAnimator(
                      "Register",
                      style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:35,fontWeight:FontWeight.bold),
                      atRestEffect: WidgetRestingEffects(duration: const Duration(seconds: 2),style: WidgetRestingEffectStyle.none),
                    ),
                    TextAnimator(
                      "Join us today! Create your account to get started.",
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
                child:Column(
                  children: [
                    MyFormField(
                      label: "Email",
                      hint: 'Enter your email',
                      borderColor: Colors.black,
                      activeBorderColor: Colors.black,
                      controller: emailController,
                      labelColor: Colors.black,
                      hintColor: Colors.grey,
                    ),
                    const SizedBox(height: 20,),
                    MyFormField(
                      label: "Password",
                      hint: 'Enter your password',
                      borderColor: Colors.black,
                      labelColor: Colors.black,
                      activeBorderColor: Colors.black,
                      openEyeIcon:  const Icon(Icons.remove_red_eye_outlined,color: Colors.black,),
                      closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: Colors.black,),
                      isPassWord: true,
                      controller: passwordController,
                      hintColor: Colors.grey,
                    ),
                    const SizedBox(height: 20,),
                    MyCustomButton(name: "Register",),
                    MyTextButton(parts: const ["already have an account"," Login"], colors: const [Colors.black,AppColors.primaryColor],onclick: loginCLick,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void loginCLick() {
    GoRouter.of(context).replace(Routes.login);
  }
}
