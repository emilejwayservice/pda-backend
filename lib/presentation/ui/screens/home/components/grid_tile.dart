import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';

class MyGridTile extends StatelessWidget {
  bool isVertival;
  String name;
  String image;
  String route;
  void Function(String)? onClick;
  MyGridTile({required this.route,required this.name,this.onClick, required this.image, this.isVertival = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onClick?.call(route),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffFEF3D2),
            borderRadius: BorderRadius.circular(15),
            /*boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 20, offset: Offset(4, 4))
            ]*/
        ),
        child: Center(
          child: isVertival
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(image),
                    Text(
                      name,
                      style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(image),
                    Text(
                      name,
                      style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
