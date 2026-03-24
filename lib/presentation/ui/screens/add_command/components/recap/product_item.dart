import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/presentation/ui/components/info_item.dart';

import '../../../../../../domain/entities/product.dart';
import '../../../../../../domain/entities/tva.dart';





class ProductItem extends StatefulWidget {
  List<TvaEntity> tva;
  ProductEntity product;
  VoidCallback? calculChanged;
  ProductItem({required this.tva,this.calculChanged,required this.product});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const  EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          InfoItem(
            name: "Article:",
            value: widget.product.labelle,
          ),
          InfoItem(
            name: "Price:",
            value: widget.product.prix.toString(),
          ),
          InfoItem(
            name: "Quantité:",
            value: widget.product.quantity.toString(),
          ),
          tvaSelector(),
          InfoItem(
            name: "Total TTC:",
            value: widget.product.ttc.toString(),
          ),
          InfoItem(
            name: "Total HT:",
            value: widget.product.ht.toString(),
          ),
        ],
      ),
    );
  }

  Widget tvaSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tva",
            style: GoogleFonts.acme(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8)
            ),
            child: DropdownButton(
                menuMaxHeight: 400,
                underline: null,
                value: widget.product.tva,
                items: List<DropdownMenuItem<int>>.from(
                    widget.tva.map((e) => DropdownMenuItem(
                      value: e.taux,
                      child: Text(
                        "${e.taux}%",
                        style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ))),
                onChanged: onChanged),
          )
        ],
      ),
    );
  }

  void onChanged(int? taux) {
    setState(() {
      widget.product.setTva=taux??0;
      widget.calculChanged?.call();
    });
  }
}




