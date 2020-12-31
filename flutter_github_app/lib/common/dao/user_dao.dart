import 'dart:convert';

import 'package:dio/dio.dart';

import 'dao_result.dart';

import '../local/local_storage.dart';
import '../config/config.dart';

import 'package:flutter_github_app/model/user.dart';

class UserDao {
  /// 获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return DataResult(user, true);
    } else {
      return DataResult(null, false);
    }
  }
}
