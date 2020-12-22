import 'package:flutter/material.dart';
import '../model/user.dart';

/// 全局 Redux store 的对象，保存 State 数据
class TTState {
  /// 用户信息
  User userInfo;

  /// 主题数据
  ThemeData themeData;

  /// 语言
  Locale locale;

  /// 当前平台默认语言
  Locale platformLocale;

  /// 是否登录
  bool login;

  TTState({
    this.userInfo,
    this.themeData,
    this.locale,
    this.login,
  });
}
