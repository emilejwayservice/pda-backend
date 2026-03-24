import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../domain/entities/chargement.dart';






class ChargementItem extends StatelessWidget {
  ChargementEntity chargement;

   ChargementItem({ required this.chargement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 11),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        tileColor: Colors.grey[100],
        title: Text(chargement.code!,style:GoogleFonts.aBeeZee(color:Colors.black,fontSize:17,fontWeight:FontWeight.bold) ,),
        subtitle: Text("${chargement.entrepot?.libelle}",style:GoogleFonts.aBeeZee(color:Colors.grey,fontSize:16,fontWeight:FontWeight.w700) ,),
      ),
    );
  }
}
