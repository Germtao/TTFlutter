import 'dart:collection';

import 'package:dio/dio.dart';
import 'code.dart';
import 'result_data.dart';
import './interceptors/index.dart';

/// http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = 'application/json';
  static const CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded';

  Dio _dio = Dio(); // 使用默认配置

  /// token 拦截器
  final TokenInterceptors _tokenInterceptors = TokenInterceptors();

  HttpManager() {
    _dio.interceptors.add(HeaderInterceptor());

    _dio.interceptors.add(_tokenInterceptors);

    _dio.interceptors.add(LogInterceptors());

    _dio.interceptors.add(ErrorInterceptors(_dio));

    _dio.interceptors.add(ResponseInterceptor());
  }

  Future<ResultData> netFetch(
    url,
    params,
    Map<String, dynamic> header,
    Options options, {
    noTip = false,
  }) async {
    Map<String, dynamic> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (options != null) {
      options.headers = headers;
    } else {
      options = Options(method: 'get');
      options.headers = headers;
    }

    resultError(DioError e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(statusCode: 666);
      }

      if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }

      return ResultData(
        Code.errorHandle(errorResponse.statusCode, e.message, noTip),
        false,
        errorResponse.statusCode,
      );
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: options);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data);
    }

    return response.data;
  }

  /// 清除授权
  clearAuthorization() {
    _tokenInterceptors.clearAuthorization();
  }

  /// 获取授权
  getAuthorization() async {
    return _tokenInterceptors.getAuthorization();
  }
}

final HttpManager httpManager = HttpManager();
