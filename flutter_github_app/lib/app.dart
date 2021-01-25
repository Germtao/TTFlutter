import 'dart:async';

import 'package:flutter_github_app/common/localization/tt_localizations_delegate.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/user.dart';
import 'package:flutter_github_app/page/common/welcome_page.dart';
import 'package:flutter_github_app/page/home/home_page.dart';
import 'package:flutter_github_app/page/login/login_page.dart';
import 'package:flutter_github_app/widget/debug/debug_label.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/common/event/http_error_event.dart';
import 'package:flutter_github_app/common/event/index.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/net/code.dart';

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
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      // 通过 with NavigatorObserver ，在这里可以获取可以往上获取到
      // MaterialApp 和 StoreProvider 的 context
      // 还可以获取到 navigator;
      // 比如在这里增加一个监听，如果 token 失效就退回登陆页
      navigator.context;
      navigator;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用 flutter_redux 做全局状态共享
    // 通过 StoreProvider 应用 store
    return StoreProvider(
      store: store,
      child: StoreBuilder<TTState>(
        builder: (context, store) {
          // 使用 StoreBuilder 获取 store 中的 theme 、locale
          store.state.platformLocale = WidgetsBinding.instance.window.locale;
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              TTLocalizationsDelegate.delegate,
            ],
            supportedLocales: [store.state.locale],
            locale: store.state.locale,
            theme: store.state.themeData,
            navigatorObservers: [this],

            // 命名式路由
            // "/" 和 MaterialApp 的 home 参数一个效果
            routes: {
              WelcomePage.className: (context) {
                _context = context;
                DebugLabel.show(context);
                return WelcomePage();
              },
              HomePage.className: (context) {
                _context = context;
                return NavigatorUtils.pageContainer(HomePage(), context);
              },
              LoginPage.className: (context) {
                _context = context;
                return NavigatorUtils.pageContainer(LoginPage(), context);
              }
            },
          );
        },
      ),
    );
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
        showToast(TTLocalizations.i18n(context).networkError);
        break;
      case 401:
        showToast(TTLocalizations.i18n(context).networkError_401);
        break;
      case 403:
        showToast(TTLocalizations.i18n(context).networkError_403);
        break;
      case 404:
        showToast(TTLocalizations.i18n(context).networkError_404);
        break;
      case 422:
        showToast(TTLocalizations.i18n(context).networkError_422);
        break;
      case Code.NETWORK_TIMEOUT:
        showToast(TTLocalizations.i18n(context).networkErrorTimeout);
        break;
      case Code.GITHUB_API_REFUSED:
        // github api 异常
        showToast(TTLocalizations.i18n(context).githubRefused);
        break;
      default:
        showToast(TTLocalizations.i18n(context).networkErrorUnknown + ' $message');
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
