import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_github_app/common/router/animation_route.dart';
import 'package:flutter_github_app/page/common/honor_list_page.dart';

import 'package:flutter_github_app/page/home/home_page.dart';
import 'package:flutter_github_app/page/issue/issue_detail_page.dart';
import 'package:flutter_github_app/page/login/login_page.dart';
import 'package:flutter_github_app/page/notify/notify_page.dart';
import 'package:flutter_github_app/page/photo/photo_view_page.dart';
import 'package:flutter_github_app/page/repos/repos_detail_page.dart';
import 'package:flutter_github_app/page/webview/tt_webview.dart';
import 'package:flutter_github_app/page/push/push_detail_page.dart';

import '../../page/common/index.dart';
import '../../page/user/index.dart';
import '../../page/debug/index.dart';

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
  static pushHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.className);
  }

  /// 跳转 登录页
  static pushLoginPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.className);
  }

  /// 图片预览
  static pushPhotoViewPage(BuildContext context, String urlStr) {
    Navigator.pushNamed(context, PhotoViewPage.className, arguments: urlStr);
  }

  /// 个人详情
  static pushPersonDetailPage(BuildContext context, String username) {
    NavigatorRouter(context, PersonDetailPage(username));
  }

  /// 跳转用户个人信息界面
  static pushUserProfileInfoPage(BuildContext context) {
    NavigatorRouter(context, UserProfileInfoPage());
  }

  /// 仓库详情
  static Future pushReposDetailPage(BuildContext context, String username, String reposname) {
    return Navigator.push(
      context,
      SizeRoute(
        widget: pageContainer(
          RepositoryDetailPage(username, reposname),
          context,
        ),
      ),
    );
  }

  /// 跳转提交详情
  static Future pushPushDetailPage(
      BuildContext context, String userName, String reposName, String sha, bool needHomeIcon) {
    return NavigatorRouter(
      context,
      PushDetailPage(
        sha,
        userName,
        reposName,
        needHomeIcon: needHomeIcon,
      ),
    );
  }

  /// 跳转 Issue 详情
  static Future pushIssueDetailPage(
    BuildContext context,
    String userName,
    String reposName,
    String issueNum, {
    bool needRightLocalIcon = false,
  }) {
    return NavigatorRouter(
      context,
      IssueDetailPage(
        userName,
        reposName,
        issueNum,
        needHomeIcon: needRightLocalIcon,
      ),
    );
  }

  /// 跳转通用列表界面
  static pushCommonListPage(
    BuildContext context,
    String title,
    String showType,
    String dataType, {
    String userName,
    String reposName,
  }) {
    NavigatorRouter(
      context,
      CommonListPage(
        title,
        showType,
        dataType,
        userName: userName,
        reposName: reposName,
      ),
    );
  }

  /// 跳转 通知消息页面
  static pushNotifyPage(BuildContext context) {
    return NavigatorRouter(context, NotifyPage());
  }

  /// 跳转 荣耀列表页面
  static pushHonorListPage(BuildContext context, List list) {
    return Navigator.push(
      context,
      SizeRoute(
        widget: pageContainer(HonorListPage(list), context),
      ),
    );
  }

  /// 跳转 调试数据界面
  static pushDebugDataPage(BuildContext context) {
    NavigatorRouter(context, DebugDataPage());
  }

  /// 跳转 搜索界面
  static pushSearchPage(BuildContext context, Offset centerPosition) {}

  /// 全屏 web 页面
  static Future pushTTWebView(BuildContext context, String urlStr, String title) {
    return NavigatorRouter(context, TTWebView(urlStr, title));
  }

  /// 公共打开方式
  // ignore: non_constant_identifier_names
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => pageContainer(widget, context),
      ),
    );
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
