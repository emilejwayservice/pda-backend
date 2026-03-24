import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_images.dart';


class AuthContainer extends StatefulWidget {
  StatefulNavigationShell navigation;
   AuthContainer(this.navigation);

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Lottie.asset(AppImages.anim_decoration),

              ],
            )
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: width,
              height: height,
              child: widget.navigation
            ),
          ),
        ],
      ),
    );
  }
}
