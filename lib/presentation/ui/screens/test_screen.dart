import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pda/core/services/qr_code_generation_service.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Uint8List? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 15,),
            ElevatedButton(
                onPressed: generateQrCode,
                child: Text("Generate")
            ),
            if(image!=null)
              Image.memory(image!)
          ],
        ),
      ),
    );
  }

  void generateQrCode() async{
    image=await QrCodeGenerationService("Saad el",100).generate();
   setState((){
   });
  }
}


