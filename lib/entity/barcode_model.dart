class BarcodeEntity{
  final String code;
  final String plu;
  int qty;

  BarcodeEntity({this.code, this.plu, this.qty});

  factory BarcodeEntity.fromJson(Map<String, dynamic> json){
    return BarcodeEntity(
      code: json['Code'],
      plu: json['PLU'],
      qty: json['Qty']
    );
  }

}