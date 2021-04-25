import 'package:layout/entity/item_model.dart';

class DetailModel{
  final int totalSKU;
  final int totalQty;
  final int totalPickedQty;
  final bool isPicked;
  final List<ItemsEntity> items;

  DetailModel({this.totalSKU, this.totalQty, this.totalPickedQty, this.isPicked, this.items});

  factory DetailModel.fromJson(Map<String, dynamic> json) =>
      DetailModel(
        totalSKU: json['TotalSKU'],
        totalQty: json['TotalQty'],
        totalPickedQty: json['TotalPickedQty'],
        isPicked: json['IsPicked'],
        items: (json['Items'] != null)
            ? List<ItemsEntity>.from(
            json['Items'].map((x) => ItemsEntity.fromJson(x)))
            : null,
      );
}