import 'package:dio/dio.dart';

/// header 拦截器
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    // 超时
    options.connectTimeout = 30000;
    options.receiveTimeout = 30000;

    return options;
  }
}
