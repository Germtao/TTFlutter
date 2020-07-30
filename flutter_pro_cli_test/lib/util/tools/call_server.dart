import 'dart:convert';

import 'package:dio/dio.dart';
import 'json_config.dart';

/// 统一调用 api 接口
class CallServer {
  /// get 方法
  static Future<Map<String, dynamic>> get(String apiName,
      [Map params = null]) async {
    // 根据类型，获取api具体信息
    Map<String, dynamic> apis = await JsonConfig.getConfig('api');
    if (apis == null) {
      return {'ret': false};
    }

    String callApi = apis[apiName]['apiUrl'] as String;

    // 处理异常情况
    if (callApi == null) {
      return {'ret': false};
    }

    // 处理参数替换
    if (params == null) {
      params.forEach(
          (key, value) => callApi = callApi.replaceAll('${key}', '$value'));
    }

    // 调用服务端接口获取返回数据
    try {
      Response response = await Dio()
          .get(callApi, options: Options(responseType: ResponseType.json));
      Map<String, dynamic> retInfo =
          json.decode(response.toString()) as Map<String, dynamic>;
      return retInfo;
    } catch (e) {
      return {'ret': false};
    }
  }
}
