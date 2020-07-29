import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

class UserInfoModel with ChangeNotifier {
  /// 用户个人信息
  final StructUserInfo userInfo;

  UserInfoModel({this.userInfo});

  /// 获取用户信息
  StructUserInfo get value => userInfo;
}
