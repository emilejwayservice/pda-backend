import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../routes.dart';

import '../../../components/text_button.dart';
import '../components/logo.dart';
import 'components/enter_email_step/enter_email_step.dart';
import 'components/enter_otp_step/enter_otp_step.dart';
import 'components/reset_pass_step/reset_password_step.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  late TextEditingController emailController;
  int activeStep=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController=TextEditingController();
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
                      "Reset password",
                      style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:35,fontWeight:FontWeight.bold),
                      atRestEffect: WidgetRestingEffects(duration: const Duration(seconds: 2),style: WidgetRestingEffectStyle.none),
                    ),
                    TextAnimator(
                      "Reset your password and regain access to your account.",
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
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                decoration:BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(3,3),blurRadius: 20)],
                    borderRadius: BorderRadius.circular(15)
                ),
                child:Column(
                  children: [
                    EasyStepper(
                      activeStep: activeStep,
                      activeStepBorderType: BorderType.normal,
                      activeStepBackgroundColor: AppColors.primaryColor,
                      borderThickness: 3,
                      lineStyle: const LineStyle(
                        activeLineColor: AppColors.primaryColor,
                        defaultLineColor: AppColors.primaryColor,
                        unreachedLineColor: Colors.grey,
                        lineThickness: 2,
                        lineType: LineType.normal,
                        lineLength: 100
                      ),
                      defaultStepBorderType: BorderType.normal,
                      activeStepTextColor: Colors.black87,
                      finishedStepTextColor: Colors.black87,
                      internalPadding: 0,
                      showLoadingAnimation: false,
                      stepRadius: 8,
                      showStepBorder: false,
                      steps: [
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor:
                              activeStep >= 0 ? Colors.orange : Colors.grey,
                            ),
                          ),
                          title: 'Email',

                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor:
                              activeStep >= 1 ? Colors.orange : Colors.grey,
                            ),
                          ),
                          topTitle: true,
                          title: 'OTP',
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor:
                              activeStep >= 2 ? Colors.orange : Colors.grey,
                            ),
                          ),
                          title: 'Reset',
                        ),

                      ],
                      onStepReached: (index) =>
                          setState(() => activeStep = index),
                    ),
                    getBody(),
                    MyTextButton(parts: const ["already have an account?"," Login"], colors: const [Colors.black,AppColors.primaryColor],onclick: loginCLick,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody(){
    switch(activeStep){
      case 0:return EnterEmailStep(onSendOtpClick: onSendOtp,);
      case 1:return EnterOtpStep(onSubmit: onEnterOtp,);
      default:return ResetPasswordStep(onResetPassword: onResetPassword,);
    }
  }
  void onSendOtp(String email){
    print(email);
    setState(() {
      activeStep=1;
    });
  }
  void onEnterOtp(String otp){
    print(otp);
    setState(() {
      activeStep=2;
    });
  }
  void onResetPassword(String newPassword){
    print(newPassword);
    GoRouter.of(context).replace(Routes.login);
  }

  void loginCLick() {
    GoRouter.of(context).replace(Routes.login);
  }


}
