import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_github_app/common/net/code.dart';
import 'package:flutter_github_app/common/net/result_data.dart';

/// 是否需要弹提示
const NO_TIP_KEY = 'noTip';

/// Error 拦截器
class ErrorInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  ErrorInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // 没有网络
    if (connectivityResult == ConnectivityResult.none) {
      return _dio.resolve(ResultData(
        Code.errorHandle(Code.NETWORK_ERROR, '', false),
        false,
        Code.NETWORK_ERROR,
      ));
    }
    return options;
  }
}
