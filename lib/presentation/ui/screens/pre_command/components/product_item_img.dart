import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pda/core/constants/products_images.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/ui/components/form_field.dart';



class MyGridTile extends StatefulWidget {
  ProductEntity product;
  void Function()? onSelectProduct;


  MyGridTile({required this.product,this.onSelectProduct}) ;


  @override
  State<MyGridTile> createState() => _MyGridTileState();
}

class _MyGridTileState extends State<MyGridTile> {
  @override
  Widget build(BuildContext context) {

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      child: GridTile(
          footer: Container(
            //padding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
            height: 50,
            color: Colors.black.withOpacity(0.6),
            child: incrementer()
          ),
        child: Image.asset(widget.product.image_path!),
      ),
    );
  }

  Widget incrementer(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: decrement,
            child: Container(
              //margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration:const BoxDecoration(
                color: Colors.red,
                //shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text("-",style: GoogleFonts.aBeeZee(fontSize:16,fontWeight:FontWeight.bold,color:Colors.white),),
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: MyFormField(
              hint: "",
              label: "",
              borderRadius: 0,
              controller: TextEditingController()..text=widget.product.quantity.toString()
                ..selection=TextSelection.fromPosition(TextPosition(offset: widget.product.quantity?.toString().length??0)),
              activeBorderColor: Colors.white,
              inputType: TextInputType.number,
              borderColor: Colors.white,
              fillColor: Colors.white,
              formatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              onChange:onChange,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: increment,
            child: Container(
              //margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration:const BoxDecoration(
                color: Colors.green,
                //shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text("+",style: GoogleFonts.aBeeZee(fontSize:16,fontWeight:FontWeight.bold,color:Colors.white),),
            ),
          ),
        ),

      ],
    );
  }

  void increment() {
    setState(() {
      widget.product.quantity=(widget.product.quantity??0)+1;
    });
    widget.onSelectProduct?.call();
  }

  void decrement() {
    if((widget.product.quantity??0)<=0)return;
   setState(() {
     widget.product.quantity=(widget.product.quantity??0)-1;
   });
    widget.onSelectProduct?.call();
  }

  void onChange(String value) {
    widget.product.quantity=int.parse(value.isEmpty?"0":value);
    widget.onSelectProduct?.call();
  }
}



