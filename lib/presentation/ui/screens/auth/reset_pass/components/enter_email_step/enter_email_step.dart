import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../../../../core/validator/validator.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/form_field.dart';

class EnterEmailStep extends StatelessWidget {
  void Function(String)? onSendOtpClick;
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  EnterEmailStep({this.onSendOtpClick});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formState,
      child: Column(
        children: [
          Text(
            "Enter your email to receive the OTP for verification.",
            style: GoogleFonts.aBeeZee(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          MyFormField(
            label: "Email",
            hint: 'Enter your email',
            borderColor: Colors.black,
            activeBorderColor: Colors.black,
            controller: controller,
            labelColor: Colors.black,
            hintColor: Colors.grey,
            validator: Validator().required().email().make(),
          ),
          const SizedBox(
            height: 20,
          ),
          MyCustomButton(
            name: "Send OTP",
            onClick: () {
              if (formState.currentState!.validate()) {
                onSendOtpClick?.call(controller.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }
}
