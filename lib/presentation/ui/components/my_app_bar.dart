import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';





class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  Widget? action;

  MyAppBar({required this.title,this.action});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      title:  Text(title,style: GoogleFonts.aBeeZee(color:Colors.white),),
      centerTitle: true,
      actions:action!=null?[
        action!
      ]:null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
