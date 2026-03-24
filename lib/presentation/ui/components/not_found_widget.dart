import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_images.dart';





class NotFoundWidget extends StatelessWidget {
  String message;
  double? imgWidth;
  NotFoundWidget({this.message="Aucune donnée!!",this.imgWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.img_empty,width: imgWidth,),
          const SizedBox(height: 10,),
          Text(message ,textAlign: TextAlign.center,style: GoogleFonts.acme(color:Colors.black,fontSize:21,fontWeight:FontWeight.bold),)
        ],
      ),
    );
  }
}

