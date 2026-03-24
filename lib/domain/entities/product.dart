class ProductEntity {
  int? id;
  String? labelle;
  String? code;
  String? marque;
  String? unitCode;
  int? unit;
  double? mesure;
  double? stock;
  double? pmp;
  int? quantity=0;
  bool isSelected;
  String? codeBar;
  double? price;
  double? priceByCategory;
  int? _tva;
  double? reel;
  double? theorique;
  String? image_path;
  String? image_url;
  int? is_sent;

  ProductEntity({
    this.id,
    this.labelle,
    this.code,
    this.marque,
    this.unit,
    this.mesure,
    this.stock,
    this.pmp,
    this.quantity=0,
    this.isSelected=false,
    this.codeBar,
    this.unitCode,
    this.price,
    this.priceByCategory,
    this.reel,
    this.theorique,
    this.image_url,
    this.image_path
  });


  set setTva(int tva){
    _tva=tva;
  }

  int get tva{
    return  _tva ?? 20;
  }

  double get prix{
    return (priceByCategory??price??0);
  }

  double get ht{
    return prix*(quantity??0);
  }

  double get ttc{
    double result=ht+totalTva;
    return result;
  }
  double get totalTva{
    double result=ht*tva/100;
    return result;
  }

  @override
  String toString() {
    return 'ProductEntity{ name:${labelle} ,quantity: $quantity, price: $price, priceByCategory: $priceByCategory, _tva: $_tva}';
  }
}
