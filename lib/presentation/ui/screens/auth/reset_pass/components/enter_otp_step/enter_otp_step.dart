import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/utils/show_toast.dart';
import '../../../../../components/custom_button.dart';



class EnterOtpStep extends StatelessWidget {
  void Function(String)? onSubmit;
  EnterOtpStep({this.onSubmit}) ;
  String? otp;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Enter the OTP sent to your email to verify.",
          style: GoogleFonts.aBeeZee(color:Colors.grey,fontWeight:FontWeight.normal,fontSize:18),),
        const SizedBox(height: 10,),
        OtpTextField(
          numberOfFields: 5,
          enabledBorderColor: Colors.grey,
          focusedBorderColor: AppColors.primaryColor,
          borderColor: Colors.grey,
          showFieldAsBox: true,
          borderRadius: BorderRadius.circular(12),
          fieldWidth: 50,
          onSubmit:(String code){
            otp=code;
          },
          cursorColor: AppColors.primaryColor,
        ),
        const SizedBox(height: 20,),
        MyCustomButton(name: "Verify",onClick: (){
          if((otp??"").isEmpty){
            showToast("OTP",context,type: ToastificationType.warning,description:"Enter the OTP sent to your email to verify." );
          }else{
            onSubmit?.call(otp!);
          }
        },)
      ],
    );
  }
}