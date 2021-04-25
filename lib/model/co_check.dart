import 'package:layout/model/plu_model.dart';
import 'package:layout/model/rows_model.dart';

class CoCheck {
  final bool status;
  final String stoCode;
  final List<RowEntity> rows;
  final List<PLUsEntity> plus;
  final String data;

  CoCheck({this.status, this.stoCode, this.rows, this.plus, this.data});

  factory CoCheck.fromJson(Map<String, dynamic> json) => CoCheck(
        status: json['Status'],
        stoCode: json['STOCode'],
        rows: (json['Rows'] != null)
            ? List<RowEntity>.from(
                json['Rows'].map((x) => RowEntity.fromJson(x)))
            : null,
        plus: (json['PLUs'] != null)
            ? List<PLUsEntity>.from(
                json['PLUs'].map((x) => PLUsEntity.fromJson(x)))
            : null,
        data: json['Data'],
      );
}
