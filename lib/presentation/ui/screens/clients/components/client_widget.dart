import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../domain/entities/client.dart';






class ClientWidget extends StatelessWidget {
  ClientEntity client;
  void Function(ClientEntity client)? onClick;
  ClientWidget({required this.client,this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
      child: ListTile(
        onTap: ()=>onClick?.call(client),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        tileColor: Colors.grey[100],
        title: Text(client.nom??"-",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color:Colors.black),),
        subtitle: Text(client.address??"-",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.w700,color:Colors.grey),),
        //trailing: Text((client.solde??0).toString(),style: GoogleFonts.aBeeZee(fontWeight:FontWeight.w700,color:Colors.green),),
      ),
    );
  }
}
