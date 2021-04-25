class SKU{
  String sku;
  int totalQty;
  int pickedTotalQty;
  List<String> listTote;

  SKU({this.sku, this.totalQty, this.pickedTotalQty, this.listTote});

  factory SKU.fromJson(Map<String, dynamic> json){
    return SKU(
      sku: json['SKU'],
      totalQty: json['TotalQty'],
      pickedTotalQty: json['PickedTotalQty'],
    );
  }
}