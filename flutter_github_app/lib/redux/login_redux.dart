import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/db/sql_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../redux/middleware/epic_store.dart';

import 'package:flutter_github_app/redux/state.dart';

import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

/// 登录相关 Redux
final LoginReducer = combineReducers<bool>([
  TypedReducer<bool, LoginSuccessAction>(_loginResult),
  TypedReducer<bool, LogoutAction>(_logoutResult),
]);

bool _loginResult(bool result, LoginSuccessAction action) {
  if (action.success == true) {
    NavigatorUtils.pushHome(action.context);
  }
  return action.success;
}

bool _logoutResult(bool result, LogoutAction action) {
  return true;
}

class LoginSuccessAction {
  final BuildContext context;
  final bool success;

  LoginSuccessAction(this.context, this.success);
}

class LogoutAction {
  final BuildContext context;

  LogoutAction(this.context);
}

class LoginAction {
  final BuildContext context;
  final String username;
  final String password;

  LoginAction(this.context, this.username, this.password);
}

class OAuthAction {
  final BuildContext context;
  final String code;

  OAuthAction(this.context, this.code);
}

class LoginMiddleware implements MiddlewareClass<TTState> {
  @override
  call(Store<TTState> store, action, next) {
    if (action is LogoutAction) {
      UserDao.clearAll(store);
      CookieManager().clearCookies();
      SqlManager.close();
      NavigatorUtils.pushLoginPage(action.context);
    }

    // 确保将操作转发到链中的下一个中间件
    next(action);
  }
}

Stream<dynamic> loginEpic(Stream<dynamic> actions, EpicStore<TTState> store) {
  Stream<dynamic> _login(LoginAction action, EpicStore<TTState> store) async* {
    CommonUtils.showLoadingDialog(action.context);
    var result = await UserDao.login(action.username.trim(), action.password.trim(), store);
    Navigator.pop(action.context);
    yield LoginSuccessAction(action.context, (result != null && result.result));
  }

  return actions.whereType<LoginAction>().switchMap((action) => _login(action, store));
}

Stream<dynamic> oAuthEpic(Stream<dynamic> actions, EpicStore<TTState> store) {
  Stream<dynamic> _login(OAuthAction action, EpicStore<TTState> store) async* {
    CommonUtils.showLoadingDialog(action.context);
    var res = await UserDao.oAuth(action.code, store);
    Navigator.pop(action.context);
    yield LoginSuccessAction(action.context, (res != null && res.result));
  }

  return actions.whereType<OAuthAction>().switchMap((action) => _login(action, store));
}
