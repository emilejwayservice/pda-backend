import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../../../core/constants/app_images.dart';




class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
        atRestEffect: WidgetRestingEffects(
            style: WidgetRestingEffectStyle.wave
        ),
        child: Image.asset(AppImages.app_logo,height: 150,
        )
    );
  }
}



