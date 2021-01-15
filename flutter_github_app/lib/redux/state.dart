import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:flutter_github_app/redux/locale_redux.dart';
import 'package:flutter_github_app/redux/login_redux.dart';
import 'package:flutter_github_app/redux/theme_redux.dart';
import 'package:flutter_github_app/redux/user_redux.dart';
import '../model/user.dart';
import 'middleware/epic_middleware.dart';

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

/// 创建 [Reducer]
/// 源码中 [Reducer] 是一个方法 [typedef State Reducer<State>(State state, dynamic action);]
/// 我们自定义了 [appReducer] 用于创建 [store]
TTState appReducer(TTState state, action) {
  return TTState(
    // 通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),
    // 通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),
    // 通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
    login: LoginReducer(state.login, action),
  );
}

final List<Middleware<TTState>> middleware = [
  EpicMiddleware<TTState>(loginEpic),
  EpicMiddleware<TTState>(userInfoEpic),
  EpicMiddleware<TTState>(oAuthEpic),
  UserInfoMiddleware(),
  LoginMiddleware(),
];
