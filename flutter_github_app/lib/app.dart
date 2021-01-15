import 'dart:async';

import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/model/user.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/common/event/http_error_event.dart';
import 'package:flutter_github_app/common/event/index.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/net/code.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> with HttpErrorListener, NavigatorObserver {
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = Store<TTState>(
    appReducer,
    // 拦截器
    middleware: middleware,
    // 初始化数据
    initialState: TTState(
      userInfo: User.empty(),
      login: false,
      themeData: CommonUtils.getThemeData(TTColors.primarySwatch),
      locale: Locale('zh', 'CH'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  StreamSubscription stream;

  /// 这里为什么用 _context 你理解吗？
  /// 因为此时 State 的 context 是 FlutterReduxApp 而不是 MaterialApp
  /// 所以如果直接用 context 是会获取不到 MaterialApp 的 Localizations
  BuildContext _context;

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  @override
  void initState() {
    super.initState();

    // Stream 演示 event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      handleError(event.code, event.message);
    });
  }

  /// 处理网络错误
  handleError(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast(TTLocalizations.i18n(context).network_error);
        break;
      case 401:
        showToast(TTLocalizations.i18n(context).network_error_401);
        break;
      case 403:
        showToast(TTLocalizations.i18n(context).network_error_403);
        break;
      case 404:
        showToast(TTLocalizations.i18n(context).network_error_404);
        break;
      case 422:
        showToast(TTLocalizations.i18n(context).network_error_422);
        break;
      case Code.NETWORK_TIMEOUT:
        showToast(TTLocalizations.i18n(context).network_error_timeout);
        break;
      case Code.GITHUB_API_REFUSED:
        // github api 异常
        showToast(TTLocalizations.i18n(context).github_refused);
        break;
      default:
        showToast(TTLocalizations.i18n(context).network_error_unknown + ' $message');
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
