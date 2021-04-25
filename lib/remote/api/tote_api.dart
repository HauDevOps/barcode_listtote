import 'dart:io';

import 'package:dio/dio.dart';
import 'package:layout/entity/co_check.dart';
import 'package:layout/entity/data_entity.dart';

class WFTApi{
  // static const String patchGetListCoCheck = '04/mdl/mdlpicklist_v1';
  // Future<CoCheck> fetchListCoCheck() async{
  //   final BaseResponse<Map<String, dynamic>> response = await RequestUtil().get<Map<String, dynamic>>(WFTApi.patchGetListCoCheck);
  //
  //   if (response.code != Constant.status_success) {
  //     return Future.error(response.message);
  //   }
  //   return CoCheck.fromJson(response.data);
  // }

  Future<DataEntity> getFetchListCoCheck() async {

    var token = 'rMxnNDLdleM9nb9fLyGi8ZVPiM9Y0M7PC6CDG7NGGhj';

    Dio dio = new Dio();
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    dio.interceptors.add(InterceptorsWrapper(
        onError: (DioError error){
          print('ApiTote error: ${error.message}');
        }
    ));

    var response = await dio.get('http://ovr-sanbox.eton.vn/wft/v1/04/mdl/mdlpicklist_v1');

    print('ApiTote response: $response');
    print('ApiTote statusCode: ${response.statusCode}');

    if (response.statusCode != HttpStatus.ok) {
      return new Future.error(response.statusMessage);
    }
    return DataEntity.fromJson(response.data);
  }
}