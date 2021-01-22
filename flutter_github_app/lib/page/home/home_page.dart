import 'dart:io';

import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';

import '../../common/utils/navigator_utils.dart';
import '../../common/style/style.dart';
import '../../common/localization/default_localizations.dart';

import 'home_drawer.dart';
import '../../page/dynamic/dynamic_page.dart';
import '../../page/trend/trend_page.dart';
import '../../page/common/my_page.dart';

import '../../widget/tab_bar/tab_bar_widget.dart';
import '../../widget/tab_bar/title_bar.dart';

class HomePage extends StatefulWidget {
  static final String className = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DynamicPageState> dynamicKey = GlobalKey();
  final GlobalKey<TrendPageState> trendKey = GlobalKey();
  final GlobalKey<MyPageState> myKey = GlobalKey();

  /// 是否退出App
  Future<bool> _dialogExitApp(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }
    return Future.value(false);
  }

  /// 渲染 Tab
  _renderTab(icon, text) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16.0),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabItems = [
      _renderTab(TTIcons.MAIN_DT, TTLocalizations.i18n(context).homeDynamic),
      _renderTab(TTIcons.MAIN_QS, TTLocalizations.i18n(context).homeTrend),
      _renderTab(TTIcons.MAIN_MY, TTLocalizations.i18n(context).homeMy),
    ];

    /// 增加返回按键监听
    return WillPopScope(
      onWillPop: () => _dialogExitApp(context),
      child: TabBarWidget(
        drawer: HomeDrawer(),
        tabType: TabType.bottom,
        tabItems: tabItems,
        tabViews: [
          DynamicPage(key: dynamicKey),
          TrendPage(key: trendKey),
          MyPage(key: myKey),
        ],
        onDoublePress: (index) {
          switch (index) {
            case 0:
              dynamicKey.currentState.scrollToTop();
              break;
            case 1:
              trendKey.currentState.scrollToTop();
              break;
            default:
          }
        },
        backgroundColor: TTColors.primarySwatch,
        indicatorColor: TTColors.white,
        title: TitleBar(
          TTLocalizations.of(context).currentLocalized.appName,
          iconData: TTIcons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onRightIconPressed: (centerPosition) => NavigatorUtils.pushSearchPage(context, centerPosition),
        ),
      ),
    );
  }
}
