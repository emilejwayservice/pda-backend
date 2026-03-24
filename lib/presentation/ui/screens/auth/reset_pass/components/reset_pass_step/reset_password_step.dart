import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../../../../core/validator/validator.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/form_field.dart';





class ResetPasswordStep extends StatelessWidget {


  final TextEditingController passwordController=TextEditingController();
  final TextEditingController confirmPasswordController=TextEditingController();
  final GlobalKey<FormState> formState=GlobalKey<FormState>();
  void Function(String)? onResetPassword;

  ResetPasswordStep({this.onResetPassword});



  @override
  Widget build(BuildContext context) {
    return Form(
      key: formState,
      child: Column(
        children: [
          Text("Set a new password and confirm it to reset.",
            style: GoogleFonts.aBeeZee(color:Colors.grey,fontWeight:FontWeight.normal,fontSize:18),),
          const SizedBox(height: 10,),
          MyFormField(
            label: "New password",
            hint: 'Enter your new password',
            borderColor: Colors.black,
            labelColor: Colors.black,
            activeBorderColor: Colors.black,
            hintColor: Colors.grey,
            openEyeIcon:  const Icon(Icons.remove_red_eye_outlined,color: Colors.black,),
            closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: Colors.black,),
            isPassWord: true,
            controller: passwordController,
            validator: Validator()
                .min(8)
                .max(20)
                .required()
                .contains([Components.numbers,Components.letters])
                .make(),
          ),
          const SizedBox(height: 10,),
          MyFormField(
            label: "Confirm password",
            hint: 'Confirm password',
            borderColor: Colors.black,
            labelColor: Colors.black,
            activeBorderColor: Colors.black,
            hintColor: Colors.grey,
            openEyeIcon:  const Icon(Icons.remove_red_eye_outlined,color: Colors.black,),
            closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: Colors.black,),
            isPassWord: true,
            controller: confirmPasswordController,
            validator: Validator()
                .required()
                .confirmPass(passwordController)
                .make(),
          ),
          const SizedBox(height: 15,),
          MyCustomButton(name: "Reset password",onClick: ()=>onResetPassClick(context),),
        ],
      ),
    );
  }

  void onResetPassClick(BuildContext context) {
    if(formState.currentState!.validate()){
      onResetPassword?.call(passwordController.text);
    }
  }






}
