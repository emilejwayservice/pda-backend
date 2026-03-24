import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../core/constants/app_colors.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitPouringHourGlassRefined(color: AppColors.primaryColor,size: 70,),
        TextAnimator(
          "Chargement...",
          style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:35,fontWeight:FontWeight.bold),
          atRestEffect: WidgetRestingEffects(duration: const Duration(seconds: 2),style: WidgetRestingEffectStyle.none),
        ),
      ],
    );
  }

}
