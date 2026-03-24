import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'as mat show Alignment ;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/bleutooth_service.dart';
import 'package:pda/presentation/blocs/livraison_details/livraison_details_bloc.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';







class BluetoothDialogue extends StatefulWidget {

  static Widget page(LivraisonDetailsBloc bloc){
    return BlocProvider.value(
        value:bloc ,
      child: BluetoothDialogue(),
    );
  }

  BluetoothDialogue({Key? key}) : super(key: key);

  @override
  State<BluetoothDialogue> createState() => _BluetoothDialogueState();
}

class _BluetoothDialogueState extends State<BluetoothDialogue> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    return Center(
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.all(15),
        width: width*0.9,
        constraints:  BoxConstraints(
          maxWidth: 400,
          maxHeight: height*0.7
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Material(
          color: Colors.white,
          child: Column(
            children: [
              Align(
                alignment: mat.Alignment.centerRight,
                child: IconButton(
                    onPressed: onClose,
                    icon: Icon(Icons.cancel_outlined,color: Colors.black,)
                ),
              ),
              Expanded(
                child: BlocBuilder<LivraisonDetailsBloc,LivraisonDetailsState>(
                  builder: (context,state){
                    List<BluetoothDevice> devices = state.devices??[];
                    if(devices.isEmpty){
                      return NotFoundWidget(
                        message: "Assurez-vous que le Bluetooth est activé et que votre imprimante est en marche.",
                      );
                    }

                    return ListView.builder(
                        itemCount:devices.length,
                        itemBuilder: (context,index){
                          BluetoothDevice device=devices.elementAt(index);
                          return ListTile(
                            leading: Icon(Icons.bluetooth,color: Colors.grey,),
                            onTap: ()=>onSelectDevice(device),
                            title:Text(device.name,style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:17),),
                            subtitle:Text(device.address,style: GoogleFonts.aBeeZee(color:Colors.grey,fontSize:15),),
                          );
                        }
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSelectDevice(BluetoothDevice device) {
    Navigator.pop(context,device);
  }

  void onClose() {
    Navigator.pop(context);
  }
}
