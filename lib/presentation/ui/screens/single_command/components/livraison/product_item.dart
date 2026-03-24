import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/domain/entities/command_details.dart';
import 'package:pda/presentation/ui/components/form_field.dart';
import 'package:pda/presentation/ui/components/info_item.dart';

import '../../../../../../domain/entities/product.dart';
import '../../../../../../domain/entities/tva.dart';





class ProductItemLivraison extends StatefulWidget {
  CommandDetailEntity detail;
  VoidCallback? calculChanged;

  ProductItemLivraison({this.calculChanged,required this.detail});

  @override
  State<ProductItemLivraison> createState() => _ProductItemLivraisonState();
}

class _ProductItemLivraisonState extends State<ProductItemLivraison> {
  late TextEditingController qtyLivController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qtyLivController=TextEditingController();
  }
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
            value: widget.detail.product?.labelle,
          ),
          InfoItem(
            name: "Price:",
            value:  widget.detail.price?.toString(),
          ),
          InfoItem(
            name: "Quantité:",
            value: widget.detail.quantity?.toString(),
          ),
          InfoItem(
            name: "Quantité restant:",
            value: widget.detail.qtyRestante?.toString(),
          ),
          quantityLivraison()

        ],
      ),
    );
  }


  Widget quantityLivraison(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Qte livraison",
            style: GoogleFonts.acme(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 100,
            height: 40,
            child: MyFormField(
              hint: "Quantité",
              label: "",
              inputType: TextInputType.number,
              onChange: onChange,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction(
                        (oldValue, newValue){
                          if(newValue.text.isEmpty){
                            return newValue;
                          }
                          int value=int.parse(newValue.text);
                          if(value>widget.detail.qtyRestante!){
                            return oldValue;
                          }
                          return newValue;
                        }
                )
              ],
              hintColor: Colors.grey,
              borderColor: Colors.black,
              activeBorderColor: Colors.black,
              controller: qtyLivController..text=widget.detail.qtyLivraison?.toString()??"",
            ),
          )
        ],
      ),
    );
  }




  void onChange(String value) {
    if(value.isEmpty){
      widget.detail.qtyLivraison=null;
    }else{
      widget.detail.qtyLivraison=int.parse(value);
    }
  }
}




