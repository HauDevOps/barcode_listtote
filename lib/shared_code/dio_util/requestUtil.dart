import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:layout/base/base_resp.dart';
import 'package:layout/base/common/define_service_api.dart';
import 'package:layout/shared_code/materials/constant.dart';
import 'package:layout/shared_code/method/constants.dart';
import 'package:layout/shared_preferences/shared_preferences.dart';
import 'dart:developer';

class RequestUtil {
  static final RequestUtil _instance = RequestUtil._internal();
  static const String TAG = 'DIO';

  // ignore: sort_constructors_first
  factory RequestUtil() => _instance;

  static bool _isDebug = false;

  static void openDebug() {
    _isDebug = true;
  }

  Dio dio;

  // ignore: sort_constructors_first
  RequestUtil._internal() {
    final options = BaseOptions(
      baseUrl: ovEnfieldServiceUrl,
      connectTimeout: 15000,
      receiveTimeout: 10000,
      headers: {},
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options) {
      if (_isDebug) {
        log(
            'DIO REQUEST[${options?.method}] => URL: ${ovEnfieldServiceUrl + options?.path}');
      }
      return options;
    }, onResponse: (response) {
      if (_isDebug) {
        log(
            'DIO RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}');
      }
      return response;
    }, onError: (e) {
      if (_isDebug) {
        log(
            'DIO ERROR[${e?.response?.statusCode}] => PATH: ${e?.request?.path}');
      }
      return createErrorEntity(e);
    }));
  }

  // Get Token
  Future getAuthorizationHeader() async {
    return await SPref.instance.get(SPrefCache.KEY_ACCESS_TOKEN);
  }

  Future addOptions(Options options) async{
    final requestOptions = options ?? Options();
    final token = await SPref.instance.get(SPrefCache.KEY_ACCESS_TOKEN);
    if (token != null) {
      requestOptions.headers['content-type'] = 'application/json';
      requestOptions.headers['Authorization'] = 'Bearer $token';
    }

    return requestOptions;
  }

  // Get
  Future get<T>(
      String path, {
        params,
        Options options,
      }) async {
    try {
      final response =
      await dio.get(path, queryParameters: params, options: await addOptions(options));
      _printHttpLog(response);
      return handleResponse<T>(response);
    } on DioError catch (e) {
      log('$TAG ${e.toString()}');
      return BaseResponse(false, createErrorEntity(e).code, createErrorEntity(e).message, null);
    }
  }

  // Post
  Future post<T>(String path, {params, Options options}) async {
    log('$TAG params $params');
    try {
      final response =
      await dio.post(path, data: params, options: await addOptions(options));
      _printHttpLog(response);
      return handleResponse<T>(response);
    } on DioError catch (e) {
      log('$TAG ${e.toString()}');
      return BaseResponse(false, createErrorEntity(e).code, createErrorEntity(e).message, null);
    }
  }

  // Put
  Future put<T>(String path, {params, Options options}) async {
    try {
      final response = await dio.put(path, data: params, options: await addOptions(options));
      _printHttpLog(response);
      return handleResponse<T>(response);
    } on DioError catch (e) {
      log('$TAG ${e.toString()}');
      return BaseResponse(false, createErrorEntity(e).code, createErrorEntity(e).message, null);
    }
  }

  BaseResponse<T> handleResponse<T>(Response response) {
    const _statusKey = 'Status';
    const _codeKey = 'Code';
    const _dataKey = 'Data';

    bool _status;
    int _code;
    T _data;

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _status = response.data[_statusKey];
          _code = (response.data[_codeKey] is String)
              ? int.tryParse(response.data[_codeKey])
              : response.data[_codeKey];
          _data = _status ? response.data[_dataKey] : null;
        } else {
          final _dataMap = _decodeData(response);
          _status = response.data[_statusKey];
          _code = (_dataMap[_codeKey] is String)
              ? int.tryParse(_dataMap[_codeKey])
              : _dataMap[_codeKey];
          _data = _status ? _dataMap[_dataKey] : null;
        }
        return BaseResponse(_status, _code, Constant.SUCCESS, _data);
      } catch (e) {
        log('$TAG ${e.toString()}');
        return null;
      }
    }
  }

  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return {};
    }
    return json.decode(response.data.toString());
  }

  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    try {
      log(
          '----------------$TAG RESPONSE---------------- +\n[data] => ${response.toString()} \n[statusCode] => ${response.statusCode.toString()} \n[requestData] => ${response.request.data.toString()}');
      log('${response.request.data.toString()}');
    } catch (ex) {
      log('$TAG Log' ' error......');
    }
  }

  Future<bool> _checkConnectionAddress() async {
    try {
      final address = '${operatorServiceUrl}swagger/';
      final uri = Uri.parse(address);

      final client = HttpClient();
      final request = await client.getUrl(uri);
      // ignore: unused_local_variable
      final response = await request.close();
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }
}

ErrorEntity createErrorEntity(DioError error) {
  switch (error.type) {
    case DioErrorType.CANCEL:
      {
        return ErrorEntity(code: -1, message: 'Yêu cầu hủy bỏ');
      }
      break;
    case DioErrorType.CONNECT_TIMEOUT:
      {
        return ErrorEntity(code: -1, message: 'Kết nối quá hạn');
      }
      break;
    case DioErrorType.SEND_TIMEOUT:
      {
        return ErrorEntity(code: -1, message: 'Yêu cầu đã hết thời gian chờ');
      }
      break;
    case DioErrorType.RECEIVE_TIMEOUT:
      {
        return ErrorEntity(code: -1, message: 'Đã hết thời gian nhận phản hồi');
      }
      break;
    case DioErrorType.RESPONSE:
      {
        try {
          final errCode = error.response.statusCode;
          switch (errCode) {
            case 400:
              {
                return ErrorEntity(
                    code: errCode, message: 'Yêu cầu lỗi cú pháp');
              }
              break;
            case 401:
              {
                return ErrorEntity(code: errCode, message: 'Quyền bị từ chối');
              }
              break;
            case 403:
              {
                return ErrorEntity(
                    code: errCode, message: 'Máy chủ từ chối thực thi');
              }
              break;
            case 404:
              {
                return ErrorEntity(
                    code: errCode, message: 'Không thể kết nối đến máy chủ');
              }
              break;
            case 405:
              {
                return ErrorEntity(
                    code: errCode, message: 'Phương thức yêu cầu bị cấm');
              }
              break;
            case 500:
              {
                return ErrorEntity(
                    code: errCode, message: 'Máy chủ lỗi nội bộ');
              }
              break;
            case 502:
              {
                return ErrorEntity(
                    code: errCode, message: 'Yêu cầu không hợp lệ');
              }
              break;
            case 503:
              {
                return ErrorEntity(code: errCode, message: 'Máy chủ đã sập');
              }
              break;
            case 505:
              {
                return ErrorEntity(
                    code: errCode,
                    message: 'Không hỗ trợ yêu cầu giao thức HTTP');
              }
              break;
            default:
              {
                return ErrorEntity(
                    code: errCode, message: error.response.statusMessage);
              }
          }
        } on Exception catch (_) {
          return ErrorEntity(code: -1, message: 'Lỗi không xác định');
        }
      }
      break;
    default:
      {
        return ErrorEntity(code: -1, message: error.message);
      }
  }
}

class ErrorEntity implements Exception {
  int code;
  String message;

  // ignore: sort_constructors_first
  ErrorEntity({this.code, this.message});

  @override
  String toString() {
    return (message == null) ? 'Lỗi không xác định' : message;
  }
}
