import 'package:flutter/material.dart';
import 'package:flutter_pro_cli_test/pages/article_detail/index.dart';
import 'package:flutter_pro_cli_test/pages/home_page/img_flow.dart';
import 'package:flutter_pro_cli_test/pages/home_page/single.dart';
import 'package:flutter_pro_cli_test/pages/user_page/guest.dart';
import 'package:flutter_pro_cli_test/util/struct/router_struct.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';

import 'pages/common/web_view_page.dart';
import 'pages/follow_page/index.dart';
import 'pages/home_page/index.dart';
import 'pages/user_page/index.dart';

/// app 协议头
const String appScheme = 'tyfapp';

/// 路由配置信息
/// widget 为组件
/// entranceIndex 为首页位置，如果非首页则为-1
/// params 为组件需要的参数数组
const Map<String, RouterStruct> routerMapping = {
  'homepage': RouterStruct(HomePageIndex(), 0, null, true),
  'followpage': RouterStruct(FollowPageIndex(), 1, null, true),
  'userpage': RouterStruct(UserPageIndex(), 2, null, true),
  'contentpage': RouterStruct(ArticleDetailIndex(), -1, ['articleId'], false),
  'default': RouterStruct(HomePageIndex(), 0, null, true),
  'imgflow': RouterStruct(HomePageImgFlow(), -1, null, true),
  'singlepage': RouterStruct(HomePageSingle(), -1, null, true),
  'userpageguest': RouterStruct(UserPageGuest(), -1, ['userId'], true),
  'error': RouterStruct(CommonError(), -1, ['errorCode', 'action'], false),
};

/// 处理APP内的跳转
class RouterManager {
  /// 执行页面跳转
  ///
  /// 需要特别注意以下逻辑
  /// -1 不在首页，则执行跳转
  /// 大于 -1 则为首页，需要在首页进行 tab 切换，而不是进行跳转
  int open(BuildContext context, String url) {
    // 非entrance入口标识
    int notEntrancePageIndex = -1;

    if (url.startsWith('https://') || url.startsWith('http://')) {
      // 打开网页
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CommonWebViewPage(url: url);
      }));

      return notEntrancePageIndex;
    }

    Map<String, dynamic> urlParseRet = _parseUrl(url);

    int entranceIndex = routerMapping[urlParseRet['action']].entranceIndex;
    if (entranceIndex > notEntrancePageIndex) {
      // 判断为首页，返回切换 tab 信息
      return entranceIndex;
    }

    Navigator.pushNamedAndRemoveUntil(context, urlParseRet['action'].toString(),
        (route) {
      if (route.settings.name == urlParseRet['action'].toString()) {
        return false;
      }
      return true;
    }, arguments: urlParseRet['params']);

    // 执行跳转，非首页
    return notEntrancePageIndex;
  }

  /// 执行页面跳转
  void push(BuildContext context, String url) {
    Map<String, dynamic> urlParseRet = _parseUrl(url);

    Navigator.pushNamedAndRemoveUntil(context, urlParseRet['action'].toString(),
        (route) {
      if (route.settings.name == urlParseRet['action'].toString()) {
        return false;
      }
      return true;
    }, arguments: urlParseRet['params']);
  }

  /// 解析跳转的url，并且分析其内部参数
  Map<String, dynamic> _parseUrl(String url) {
    if (url.startsWith(appScheme)) {
      url = url.substring(9);
    }

    int placeIndex = url.indexOf('?');

    if (url == '' || url == null) {
      return {'action': 'default', 'params': null};
    }

    if (placeIndex < 0) {
      return {'action': url, 'params': null};
    }

    String action = url.substring(0, placeIndex);
    String paramStr = url.substring(placeIndex + 1);

    if (paramStr == null) {
      return {'action': action, 'params': null};
    }

    Map params = {};
    List<String> paramsStrArr = paramStr.split('&');

    for (String singleParamsStr in paramsStrArr) {
      List<String> singleParamsArr = singleParamsStr.split('=');
      // 获取组件参数
      if (routerMapping[action].params != null) {
        List<String> paramsList = routerMapping[action].params;
        if (paramsList.indexOf(singleParamsArr[0]) > -1) {
          params[singleParamsArr[0]] = singleParamsArr[1];
        }
      }
    }
    return {'action': action, 'params': params};
  }

  /// 增加 scaffold
  Widget _buildPage(Widget widgetPage) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: widgetPage,
      ),
    );
  }

  /// 注册路由事件
  Map<String, Widget Function(BuildContext)> registerRouter() {
    Map<String, Widget Function(BuildContext)> routerInfo = {};

    routerMapping.forEach((routerName, routerData) {
      if (routerName.toString() == 'default') {
        // 默认逻辑不处理
        return;
      }

      if (routerData.needScaffold) {
        routerInfo[routerName.toString()] =
            (context) => _buildPage(routerData.widget);
      } else {
        routerInfo[routerName.toString()] = (context) => routerData.widget;
      }
    });

    return routerInfo;
  }

  /// 根据页面路由，获取页面信息
  Widget getPageByRouter(String pageName) {
    Widget pageWidget;
    if (routerMapping[pageName] != null) {
      pageWidget = routerMapping[pageName].widget;
    } else {
      pageWidget = routerMapping['default'].widget;
    }
    return pageWidget;
  }
}
