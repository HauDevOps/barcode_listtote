import 'dart:convert';

import 'package:layout/model/co_check.dart';
import 'package:layout/model/data_entity.dart';
import 'package:layout/remote/api/tote_api.dart';
import 'package:layout/shared_code/materials/constant.dart';
import 'package:layout/shared_preferences/shared_preferences.dart';

class Repository {
  final WFTApi _wftApi = WFTApi();

  // Future<DataEntity> fetchListCoCheck() async {
  //   return await WFTApi().getFetchListCoCheck();
  // }

  Future<CoCheck> fetchCoCheck() async {
    return await _wftApi.fetchListCoCheck();
  }

  Future<CoCheck> fetchCoCheckLocal() async {
    final data = await SPref.instance.get(SPrefCache.KEY_CO_CHECK);
    return CoCheck.fromJson(jsonDecode(data));
  }

  Future<CoCheck> submitCoCheck(Map<String, dynamic> data) async{
    return await _wftApi.submitCoCheck(data);
  }
}
