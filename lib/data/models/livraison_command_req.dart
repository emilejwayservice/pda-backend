import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/domain/entities/livraison_command_req.dart';




class LivComdReqModel{
  int? command;
  int? company;
  int? entrepot;
  DateTime? dateLivraison;
  List<Map<String,dynamic>>? products;

  LivComdReqModel({
    this.command,
    this.company,
    this.entrepot,
    this.dateLivraison,
    this.products,
  });

  Map<String,dynamic> toJson(){
    return {
      "command":command,
      "company":company,
      "dateLivraison":dateLivraison?.formattedDateEn,
      "entrepot":entrepot,
      "products":products
    };
  }

  static LivComdReqModel toModel(LivComdReqEntity cmd){
    return LivComdReqModel(
      command: cmd.command,
      company: cmd.company,
      entrepot: cmd.entrepot,
      dateLivraison: cmd.dateLivraison,
      products: cmd.products
    );
  }


}
