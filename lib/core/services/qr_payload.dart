



import 'package:pda/core/extensions/extension_on_date.dart';

class QrPayload{


  static String generatePayload(int idLivraison){
    return "${DateTime.now().formatterDateNoDelimeter}-${idLivraison}";
  }
  static int? getIdLivraison(String payLoad){
    RegExp regExp=RegExp(r"^\d+-\d+$");
    if(regExp.hasMatch(payLoad)){
      String liv=payLoad.split('-').elementAt(1);
      return int.parse(liv);
    }
    return null;
  }


}