import 'package:dio/dio.dart';
import 'package:flutter_github_app/common/net/code.dart';
import 'package:flutter_github_app/common/net/result_data.dart';

/// Response 拦截器
class ResponseInterceptor extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    RequestOptions options = response.request;
    var value;
    try {
      var header = response.headers[Headers.contentTypeHeader];
      if (header != null && header.toString().contains('text')) {
        value = ResultData(response.data, true, Code.SUCCESS);
      } else if (response.statusCode >= 200 && response.statusCode < 300) {
        value = ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      print('on response error: ${e.toString() + options.path}');
      value = ResultData(response.data, false, response.statusCode, headers: response.headers);
    }
    return value;
  }
}
