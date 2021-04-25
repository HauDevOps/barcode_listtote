import 'package:layout/entity/co_check.dart';
import 'package:layout/entity/data_entity.dart';
import 'package:layout/remote/api/tote_api.dart';

class Repository{
  Future<DataEntity> fetchListCoCheck() async {
    return await WFTApi().getFetchListCoCheck();
  }
}