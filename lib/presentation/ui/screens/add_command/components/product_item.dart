import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/presentation/ui/components/form_field.dart';

import '../../../../../domain/entities/product.dart';






class ProductItem extends StatefulWidget {
  ProductEntity product;
  void Function(ProductEntity)? onSelectProduct;
  ProductItem({required this.product,this.onSelectProduct}) ;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late TextEditingController controller;
  late FocusNode focusNode;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TextEditingController();
    focusNode=FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${widget.product.labelle}",style: GoogleFonts.aBeeZee(color:Colors.black,fontWeight:FontWeight.w700,fontSize:16),),
                  Text("${widget.product.priceByCategory ?? widget.product.price}",style: GoogleFonts.aBeeZee(color:Colors.grey,fontWeight:FontWeight.w400,fontSize:14),)
                ],
              )
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(widget.product.isSelected)
              SizedBox(
                width: 80,
                child:MyFormField(
                  hint: "",
                  label: "",
                  controller: controller..text=(widget.product.quantity??"").toString(),
                  onChange: onChange,
                  readOnly:!widget.product.isSelected ,
                  inputType: TextInputType.number,
                  focusNode: focusNode,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  borderColor: widget.product.isSelected?Colors.black:Colors.grey,
                  activeBorderColor: widget.product.isSelected?Colors.black:Colors.grey,
                ) ,
              ),
              Checkbox(
                  value: widget.product.isSelected,
                  activeColor:Colors.black,
                  checkColor: AppColors.primaryColor,
                  onChanged:onSelect
              )
            ],
          ),
        ],
      ),
    );
  }

  void onChange(String value) {
    widget.product.quantity=int.tryParse(value);
  }

  void onSelect(bool? value) {
    setState(() {
      widget.product.isSelected=value!;
      if(value){
        focusNode.requestFocus();
      }else{
        widget.product.quantity=null;
        controller.clear();
      }
    });
    widget.onSelectProduct?.call(widget.product);
  }
}
