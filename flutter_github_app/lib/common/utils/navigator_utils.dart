import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_github_app/page/home/home_page.dart';

class NavigatorUtils {
  /// 替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  /// 切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  /// 主页
  static pushHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.className);
  }

  /// 公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => pageContainer(widget, context),
        ));
  }

  /// Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: widget,
    );
  }

  /// 弹出 diaglog
  static Future<T> showTTDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return MediaQuery(
            // 不受系统字体缩放影响
            data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
            child: SafeArea(
              child: builder(context),
            ),
          );
        });
  }
}
