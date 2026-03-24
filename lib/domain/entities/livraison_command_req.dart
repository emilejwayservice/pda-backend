



class LivComdReqEntity{
  int? command;
  int? company;
  int? entrepot;
  DateTime? dateLivraison;
  List<Map<String,dynamic>>? products;

  LivComdReqEntity({
    this.command,
    this.company,
    this.entrepot,
    this.dateLivraison,
    this.products,
  });
}
