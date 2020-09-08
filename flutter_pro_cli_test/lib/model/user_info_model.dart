import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

/// 用户信息 model
class UserInfoModel with ChangeNotifier {
  /// 用户个人信息
  final StructUserInfo userInfo;

  /// 构造函数
  UserInfoModel({this.userInfo});

  /// 获取用户信息
  StructUserInfo get value => userInfo;
}
