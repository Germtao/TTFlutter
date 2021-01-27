import 'package:dio/dio.dart';

/// header 拦截器
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    // 超时
    options.connectTimeout = 30000;
    options.receiveTimeout = 30000;

    return options;
  }
}
