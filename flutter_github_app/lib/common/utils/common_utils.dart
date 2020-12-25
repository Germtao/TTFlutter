import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_github_app/common/config/config.dart';
import 'package:flutter_github_app/common/local/local_storage.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../net/address.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as Cache;
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:redux/redux.dart';
import 'package:flutter_github_app/redux/theme_redux.dart';
import 'package:flutter_github_app/redux/locale_redux.dart';
import 'package:flutter_github_app/widget/button/tt_flex_button.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/page/issue/issue_edit_dialog.dart';

class CommonUtils {
  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Locale currentLocale;

  /// 获取日期字符串
  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }

  static String getUserChartAddress(String username) {
    return Address.graphicHost + TTColors.primaryValueString.replaceAll('#', '') + '/$username';
  }

  /// 日期格式转换
  static String getNewsTimeStr(DateTime date) {
    int subTimes = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTimes < MILLIS_LIMIT) {
      return (currentLocale != null)
          ? (currentLocale.languageCode != 'zh')
              ? 'right now'
              : '刚刚'
          : '刚刚';
    } else if (subTimes < SECONDS_LIMIT) {
      return (subTimes / MILLIS_LIMIT).round().toString() +
          ((currentLocale != null)
              ? (currentLocale.languageCode != 'zh')
                  ? ' seconds ago'
                  : ' 秒前'
              : ' 秒前');
    } else if (subTimes < MINUTES_LIMIT) {
      return (subTimes / SECONDS_LIMIT).round().toString() +
          ((currentLocale != null)
              ? (currentLocale.languageCode != 'zh')
                  ? ' min ago'
                  : ' 分钟前'
              : ' 分钟前');
    } else if (subTimes < HOURS_LIMIT) {
      return (subTimes / MINUTES_LIMIT).round().toString() +
          ((currentLocale != null)
              ? (currentLocale.languageCode != 'zh')
                  ? ' hours ago'
                  : ' 小时前'
              : ' 小时前');
    } else if (subTimes < DAYS_LIMIT) {
      return (subTimes / HOURS_LIMIT).round().toString() +
          ((currentLocale != null)
              ? (currentLocale.languageCode != 'zh')
                  ? ' days ago'
                  : ' 天前'
              : ' 天前');
    } else {
      return getDateStr(date);
    }
  }

  /// 获取本地路径
  static getLocalPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
      if (statuses[Permission.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    String appDocPath = appDir.path + '/ttgithubappflutter';
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  static String removeTextTag(String description) {
    if (description != null) {
      String reg = '<g-emoji.*?>.+?</g-emoji>';
      RegExp tag = RegExp(reg);
      Iterable<Match> tags = tag.allMatches(description);
      for (Match m in tags) {
        String match = m.group(0).replaceAll(RegExp('<g-emoji.*?>'), '').replaceAll(RegExp('</g-emoji>'), '');
        description = description.replaceAll(RegExp(m.group(0)), match);
      }
    }
    return description;
  }

  /// 保存图片
  static saveImage(String urlStr) async {
    Future<String> _findPath(String imageUrl) async {
      final file = await Cache.DefaultCacheManager().getSingleFile(urlStr);
      if (file == null) {
        return null;
      }

      Directory localPath = await CommonUtils.getLocalPath();
      if (localPath == null) {
        return null;
      }

      final name = splitFileNameByPath(file.path);
      final result = await file.copy(localPath.path + name);
      return result.path;
    }

    return _findPath(urlStr);
  }

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf('/'));
  }

  static getFullName(String reposUrl) {
    if (reposUrl != null && reposUrl.substring(reposUrl.length - 1) == '/') {
      reposUrl = reposUrl.substring(0, reposUrl.length - 1);
    }
    String fullName = '';
    if (reposUrl != null) {
      List<String> splicurl = reposUrl.split('/');
      if (splicurl.length > 2) {
        fullName = splicurl[splicurl.length - 2] + '/' + splicurl[splicurl.length - 1];
      }
    }
    return fullName;
  }

  /// 跳转主题
  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = getThemeData(colors[index]);
    store.dispatch(RefreshThemeDataAction(themeData));
  }

  /// 获取主题数据
  static getThemeData(Color color) {
    return ThemeData(primarySwatch: color, platform: TargetPlatform.android);
  }

  /// 获取主题色数组
  static List<Color> getThemeListColor() {
    return [
      TTColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  /// 显示语言弹窗
  static showLanguageDialog(BuildContext context) {
    List<String> list = [
      TTLocalizations.i18n(context).home_language_default,
      TTLocalizations.i18n(context).home_language_zh,
      TTLocalizations.i18n(context).home_language_en,
    ];
    CommonUtils.showCommitOptionDialog(context, list, (index) {
      CommonUtils.changeLocale(StoreProvider.of<TTState>(context), index);
      LocalStorage.save(Config.LOCALE, index.toString());
    }, height: 150.0);
  }

  /// 切换语言
  static changeLocale(Store<TTState> store, int index) {
    Locale locale = store.state.platformLocale;
    if (Config.DEBUG) {
      print(locale);
    }
    switch (index) {
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    currentLocale = locale;
    store.dispatch(RefreshLocaleAction(locale));
  }

  /// 获取设备信息
  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return '';
    }
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.model;
  }

  /// 列表 item dialog
  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    List<String> commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color> colorList,
  }) {
    return NavigatorUtils.showTTDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: TTColors.white,
              // 用一个 BoxDecoration 装饰器提供背景图片
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: ListView.builder(
              itemCount: commitMaps.length,
              itemBuilder: (BuildContext context, int index) {
                return TTFlexButton(
                  maxLines: 1,
                  mainAxisAlignment: MainAxisAlignment.start,
                  fontSize: 14.0,
                  color: colorList != null ? colorList[index] : Theme.of(context).primaryColor,
                  text: commitMaps[index],
                  textColor: TTColors.white,
                  onPress: () {
                    Navigator.pop(context);
                    onTap(index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  static const IMAGE_END = ['.png', '.jpg', '.jpeg', '.gif', '.svg'];

  static isImageEnd(String path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  static copy(String data, BuildContext context) {
    Clipboard.setData(ClipboardData(text: data));
    Fluttertoast.showToast(msg: TTLocalizations.i18n(context).option_share_copy_success);
  }

  static launchUrl(context, String urlStr) {
    if (urlStr == null || urlStr.length == 0) {
      return;
    }

    Uri parseUri = Uri.parse(urlStr);
    bool isImage = isImageEnd(parseUri.toString());

    if (parseUri.toString().endsWith('?raw=true')) {
      isImage = isImageEnd(parseUri.toString().replaceAll('?raw=true', ''));
    }

    if (isImage) {
      NavigatorUtils.pushPhotoViewPage(context, urlStr);
      return;
    }

    if (parseUri != null && parseUri.host == 'github.com' && parseUri.path.length > 0) {
      List<String> pathNames = parseUri.path.split('/');
      if (pathNames.length == 2) {
        // 解析人
        String username = pathNames[1];
        NavigatorUtils.pushPersonDetailPage(context, username);
      } else if (pathNames.length >= 3) {
        String username = pathNames[1];
        String reposName = pathNames[2];
        // 解析仓库
        if (pathNames.length == 3) {
          NavigatorUtils.pushReposDetailPage(context, username, reposName);
        } else {
          launchWebView(context, '', urlStr);
        }
      }
    } else if (urlStr != null && urlStr.startsWith('http')) {
      launchWebView(context, '', urlStr);
    }
  }

  static void launchWebView(BuildContext context, String title, String urlStr) {
    if (urlStr.startsWith('http')) {
      NavigatorUtils.pushTTWebView(context, urlStr, title);
    } else {
      NavigatorUtils.pushTTWebView(
        context,
        Uri.dataFromString(
          urlStr,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        title,
      );
    }
  }

  static launchOutURL(String urlStr, BuildContext context) async {
    if (await canLaunch(urlStr)) {
      await launch(urlStr);
    } else {
      Fluttertoast.showToast(
        msg: TTLocalizations.i18n(context).option_web_launcher_error + ': $urlStr',
      );
    }
  }

  /// 显示加载 dialog
  static Future<Null> showLoadingDialog(BuildContext context) {
    return NavigatorUtils.showTTDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: WillPopScope(
            onWillPop: () => Future.value(false),
            child: Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: SpinKitCubeGrid(
                        color: TTColors.white,
                      ),
                    ),
                    Container(
                      height: 10.0,
                    ),
                    Container(
                      child: Text(
                        TTLocalizations.i18n(context).loading_text,
                        style: TTConstant.normalTextWhite,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 显示编辑 dialog
  static Future<Null> showEditDialog(
    BuildContext context,
    String diaglogTitle,
    ValueChanged<String> onTitleChanged,
    ValueChanged<String> onContentChanged,
    VoidCallback onPressed, {
    TextEditingController titleController,
    TextEditingController valueController,
    bool needTitle = true,
  }) {
    return NavigatorUtils.showTTDialog(
      context: context,
      builder: (context) {
        return Center(
          child: IssueEditDialog(
            diaglogTitle,
            onTitleChanged,
            onContentChanged,
            onPressed,
            titleController: titleController,
            valueController: valueController,
            needTitle: needTitle,
          ),
        );
      },
    );
  }

  /// 版本更新 dialog
  static Future<Null> showUpdateDialog(BuildContext context, String contentMsg) {
    return NavigatorUtils.showTTDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TTLocalizations.i18n(context).app_version_title),
          content: Text(contentMsg),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TTLocalizations.i18n(context).app_cancel),
            ),
            FlatButton(
              onPressed: () {
                launch(Address.updateUrl);
                Navigator.pop(context);
              },
              child: Text(TTLocalizations.i18n(context).app_ok),
            )
          ],
        );
      },
    );
  }
}
