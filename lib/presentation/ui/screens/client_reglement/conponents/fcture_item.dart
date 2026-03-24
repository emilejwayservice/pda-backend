import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/validator/validator.dart';

import '../../../../../domain/entities/facture.dart';
import '../../../components/form_field.dart';

class FactureItem extends StatefulWidget {
  FactureEntity facture;

  FactureItem({required this.facture});

  @override
  State<FactureItem> createState() => _FactureItemState();
}

class _FactureItemState extends State<FactureItem> {

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
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.facture.dateFacture?.formattedDateFr}",style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:17,fontWeight:FontWeight.bold),),
                const SizedBox(height: 6,),
                Text("${widget.facture.montantRestant}",style: GoogleFonts.aBeeZee(color:Colors.green,fontWeight:FontWeight.bold,fontSize:16),),
              ],
            ),
          ),
          quantityLivraison()
        ],
      ),
    );
  }

  Widget quantityLivraison(){
    return SizedBox(
      width: 100,
      height: 40,
      child: MyFormField(
        hint: "Montant",
        label: "",
        inputType: TextInputType.number,
        onChange: onChange,
        formatters: [
          TextInputFormatter.withFunction(filter)
        ],
        hintColor: Colors.grey,
        borderColor: Colors.black,
        activeBorderColor: Colors.black,
        controller: qtyLivController..text=widget.facture.montantToPay?.toString()??"",
      ),
    );
  }


  void onChange(String value) {
    if(value.isEmpty){
      widget.facture.montantToPay=null;
    }else{
      widget.facture.montantToPay=double.parse(value);
    }
  }



  TextEditingValue filter(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty){
      return newValue;
    }
    RegExp regExp=RegExp(r"^\d+\.?\d*$");
    if(!regExp.hasMatch(newValue.text)){
      return oldValue;
    }
    String newVal=newValue.text;
    if(newVal.indexOf(".")==(newVal.length-1)){
      newVal=newVal.replaceAll(".", "");
    }
    double value=double.parse(newVal);
    if(value>(widget.facture.montantRestant??0)){
      return oldValue;
    }
    return newValue;
  }
}
