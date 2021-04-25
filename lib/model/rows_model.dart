import 'package:layout/model/detail_model.dart';

class RowEntity {
  final String pickListCode;
  final String storeEtonCode;
  final int pickedQty;
  final int qty;
  final String tote;
  final bool isFinish;
  final DetailModel detail;

  RowEntity(
      {this.pickListCode,
      this.storeEtonCode,
      this.pickedQty,
      this.qty,
      this.tote,
      this.isFinish,
      this.detail});

  factory RowEntity.fromJson(Map<String, dynamic> json) => RowEntity(
        pickListCode: json['PickListCode'],
        storeEtonCode: json['StoreEtonCode'],
        pickedQty: json['PickedQty'],
        qty: json['Qty'],
        tote: json['Tote'],
        isFinish: json['IsFinish'],
        detail: DetailModel.fromJson(json['Details']),
      );
}
