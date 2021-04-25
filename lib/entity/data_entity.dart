import 'package:layout/entity/co_check.dart';

class DataEntity{

  bool status;
  int code;
  CoCheck data;

  DataEntity({this.status, this.code, this.data});

  factory DataEntity.fromJson(Map<String, dynamic> json) => DataEntity(
    status: json['Status'],
    code: json['Code'],
    data: CoCheck.fromJson(json['Data']),
  );
}