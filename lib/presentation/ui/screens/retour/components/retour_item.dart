import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';

import '../../../../../domain/entities/retour.dart';



class RetourItem extends StatelessWidget {
  RetourEntity retour;
  void Function(RetourEntity retour)? onClick;

  RetourItem({required this.retour,this.onClick}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0,right: 18.0,top: 27),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ListTile(
            onTap: ()=>onClick?.call(retour),
            contentPadding: const EdgeInsets.symmetric(vertical:13 ,horizontal: 16),
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            title: Text(retour.client?.nom??"-",
              style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18,fontWeight:FontWeight.bold),) ,
            subtitle: Text(retour.dateRetour?.formattedDateFr??"-",
              style: GoogleFonts.aBeeZee(color:Colors.grey,fontSize:16,fontWeight:FontWeight.w500),) ,
            //trailing: Text(re??"-",style: GoogleFonts.aBeeZee(color:Colors.green,fontSize:18,fontWeight:FontWeight.w700),),
          ),
          Positioned(
            right: 10,
            top: -19,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
              decoration: BoxDecoration(
                  color: retour.status?.color?.toColor,
                  borderRadius: BorderRadius.circular(7)
              ),
              child: Text(retour.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
}




