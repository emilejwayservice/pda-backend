import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/pre_command/pre_command_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';




class Recap extends StatefulWidget {
  Recap({Key? key}) : super(key: key);

  static Widget page(PreCommandBloc bloc){
    return BlocProvider.value(
        value: bloc,
      child: Recap(),
    );
  }

  @override
  State<Recap> createState() => _RecapState();
}

class _RecapState extends State<Recap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Command",
      ),
      body:Column(
        children: [
          BlocListener<PreCommandBloc,PreCommandState>(
              listener: listener,
            child: SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<PreCommandBloc,PreCommandState>(
              builder: (context,state){
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.productsNotSent?.length??0,
                          itemBuilder: (context,index){
                            ProductEntity product=state.productsNotSent!.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                tileColor: Colors.grey[100],
                                title: Text("${product.labelle}",style: GoogleFonts.aBeeZee(color:Colors.black,fontWeight:FontWeight.bold),),
                                trailing: Text("${product.quantity}",style: GoogleFonts.aBeeZee(color:Colors.grey,fontWeight:FontWeight.w600),),
                              ),
                            );
                          }
                      ),
                    ),
                    MyCustomButton(name: "Ajouter",color: Colors.green,textColor: Colors.white,onClick: addCommand,)
                  ],
                );
              },
            ),
          ),
        ],
      )
    );
  }

  void addCommand() {
    BlocProvider.of<PreCommandBloc>(context).add(AddCommand());
  }

  void listener(BuildContext context, PreCommandState state) {
    if(state.updateSentProducts==AppStatus.success){
      Navigator.pop(context);
    }
  }
}




