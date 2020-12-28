import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_github_app/common/config/config.dart';

/// Log 拦截器
class LogInterceptors extends InterceptorsWrapper {
  static List<Map> sHttpResponses = List<Map>();
  static List<String> sResponsesHttpUrl = List<String>();

  static List<Map<String, dynamic>> sHttpRequest = List<Map<String, dynamic>>();
  static List<String> sRequestHttpUrl = List<String>();

  static List<Map<String, dynamic>> sHttpError = List<Map<String, dynamic>>();
  static List<String> sErrorHttpUrl = List<String>();

  @override
  Future onRequest(RequestOptions options) async {
    if (Config.DEBUG) {
      print('请求url: ${options.path}');
      print('请求头: ${options.headers.toString()}');
      if (options.data != null) {
        print('请求参数: ${options.data.toString()}');
      }
    }

    try {
      addLogic(sRequestHttpUrl, options.path ?? '');
      var data;
      if (options.data is Map) {
        data = options.data;
      } else {
        data = Map<String, dynamic>();
      }
      var map = {
        'header': {...options.headers}
      };
      if (options.method == 'POST') {
        map['data'] = data;
      }
      addLogic(sHttpRequest, map);
    } catch (e) {
      print('on request error: $e');
    }
    return options;
  }

  @override
  Future onResponse(Response response) async {
    if (Config.DEBUG) {
      if (response != null) {
        print('返回参数: ${response.toString()}');
      }
    }

    if (response.data is Map || response.data is List) {
      try {
        var data = Map<String, dynamic>();
        data['data'] = data;
        addLogic(sResponsesHttpUrl, response?.request?.uri?.toString() ?? '');
        addLogic(sHttpResponses, data);
      } catch (e) {
        print('on response error: $e');
      }
    } else if (response.data is String) {
      try {
        var data = Map<String, dynamic>();
        data['data'] = data;
        addLogic(sResponsesHttpUrl, response?.request?.uri?.toString() ?? '');
        addLogic(sHttpResponses, data);
      } catch (e) {
        print('on response error-1: $e');
      }
    } else if (response.data != null) {
      try {
        String data = response.data.toJson();
        addLogic(sResponsesHttpUrl, response?.request?.uri?.toString() ?? '');
        addLogic(sHttpResponses, json.decode(data));
      } catch (e) {
        print('on response error-2: $e');
      }
    }
    return response;
  }

  @override
  Future onError(DioError err) async {
    if (Config.DEBUG) {
      print('请求异常: ${err.toString()}');
      print('请求异常信息: ${err.response?.toString() ?? ''}');
    }
    try {
      addLogic(sErrorHttpUrl, err.request.path ?? 'null');
      var errors = Map<String, dynamic>();
      errors['error'] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      print('on error: $e');
    }
    return err;
  }

  /// 添加逻辑
  static addLogic(List list, data) {
    if (list.length > 20) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
