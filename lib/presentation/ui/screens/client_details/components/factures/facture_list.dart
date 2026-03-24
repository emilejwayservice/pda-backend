import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/domain/entities/facture.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';

import '../../../../../../domain/entities/Livraison.dart';
import '../../../../../blocs/client_details/client_detail_bloc.dart';
import 'facture_detail.dart';


class FactureList extends StatelessWidget {

  FactureList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientDetailBloc, ClientDetailState>(
  builder: (context, state) {
    List<FactureEntity> factures=state.client?.factures??[];
    return Scaffold(
      appBar: MyAppBar(
        title: "Factures",
      ),
      body: factures.isEmpty
          ?NotFoundWidget()
          :ListView.builder(
        itemCount: factures.length,
          itemBuilder: (context,index){
            FactureEntity facture=factures.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18.0,top: 27),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ListTile(
                    onTap: ()=>onLIvraisonClick(facture,context),
                    contentPadding: const EdgeInsets.symmetric(vertical:13 ,horizontal: 16),
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    title: Text(facture.dateFacture?.formattedDateFr??"-",
                      style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18,fontWeight:FontWeight.bold),) ,
                    trailing: Text(facture.totalTTC?.toString()??"-",style: GoogleFonts.aBeeZee(color:Colors.green,fontSize:18,fontWeight:FontWeight.w700),),
                  ),
                  Positioned(
                    right: 10,
                    top: -19,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      decoration: BoxDecoration(
                        color: facture.status?.color?.toColor,
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child: Text(facture.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  },
);
  }

  onLIvraisonClick(FactureEntity facture,BuildContext context) {
    Navigator.push(
        context,
      MaterialPageRoute(
          builder: (context)=>FactureDetailScreen(facture: facture,)
      )
    );
  }
}
