import 'barcode_model.dart';

class ItemsEntity {
  final String pickListCode;
  final String storeEtonCode;
  final String storeName;
  final String sku;
  List<BarcodeEntity> barCodes;
  final String productName;
  int pickedQty;
  final int qty;
  final String tote;

  ItemsEntity(
      {this.pickListCode,
      this.storeEtonCode,
      this.storeName,
      this.sku,
      this.barCodes,
      this.productName,
      this.pickedQty,
      this.qty,
      this.tote});

  factory ItemsEntity.fromJson(Map<String, dynamic> json) => ItemsEntity(
        pickListCode: json['PickListCode'],
        storeEtonCode: json['StoreEtonCode'],
        storeName: json['StoreName'],
        sku: json['SKU'],
        barCodes: (json['Barcode'] != null)
            ? List<BarcodeEntity>.from(
                json['Barcode'].map((x) => BarcodeEntity.fromJson(x)))
            : null,
        productName: json['ProductName'],
        pickedQty: json['PickedQty'],
        qty: json['Qty'],
        tote: json['Tote'],
      );
}
