import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/presentation/ui/components/info_item.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';





class CommandDetailScreen extends StatelessWidget {
  CommandEntity command;

  CommandDetailScreen({required this.command});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Command details",
      ),
      body: Column(
        children: [
          InfoItem(
            name: "Date livraison",
            value: command.dateCommand?.formattedDateFr,
          ),
          InfoItem(
            name: "total HT",
            value: command.totalHt?.toString()??"-",
          ),
          InfoItem(
            name: "total TTC",
            value: command.totalTTC?.toString()??"-",
          ),
          InfoItem(
            name: "total TVA",
            value: command.totalTva?.toString()??"-",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Statut",
                  style: GoogleFonts.acme(
                      color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  decoration: BoxDecoration(
                      color: command.status?.color?.toColor,
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: Text(command.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Expanded(
              child:Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Text("Details",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color:Colors.black,fontSize:18),),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                            itemCount: command.details?.length??0,
                            itemBuilder: (context,index){
                              CommandDetailEntity detail=command.details!.elementAt(index);
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Column(
                                  children: [
                                    InfoItem(
                                      name: "Article",
                                      value: detail.product?.labelle,
                                    ),
                                    InfoItem(
                                      name: "Prix",
                                      value: detail.price?.toString()??"-",
                                    ),
                                    InfoItem(
                                      name: "Quantité",
                                      value: detail.quantity?.toString()??"-",
                                    ),
                                    InfoItem(
                                      name: "Quantité restante",
                                      value: detail.qtyRestante?.toString()??"-",
                                    ),
                                    InfoItem(
                                      name: "Total HT",
                                      value: detail.totalHt?.toString()??"-",
                                    ),
                                    InfoItem(
                                      name: "Total TTC",
                                      value: detail.totalTTC?.toString()??"-",
                                    ),
                                    InfoItem(
                                      name: "Total TVA",
                                      value: detail.totalTva?.toString()??"-",
                                    ),
                                  ],
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}



