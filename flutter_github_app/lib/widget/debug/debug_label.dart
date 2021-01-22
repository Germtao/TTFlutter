import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/env/config_wrapper.dart';
import 'package:package_info/package_info.dart';

class DebugLabel {
  static bool hadShow = false;
  static OverlayEntry _overlayEntry;

  static show(BuildContext context) async {
    if (!ConfigWrapper.of(context).debug) {
      return false;
    }

    if (hadShow) {
      return false;
    }

    hadShow = true;
    var list = await _getDeviceInfo();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var language = TTLocalizations.of(context).locale.languageCode;
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    var overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return GlobalLabel(
        version: packageInfo.version,
        deviceInfo: list[0],
        platform: list[1],
        language: language,
      );
    });
    overlayState.insert(_overlayEntry);
  }

  static reset(BuildContext context) {
    hide();
    show(context);
  }

  static hide() {
    hadShow = false;
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}

/// 获取设备信息
Future<List<String>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    return [androidDeviceInfo.version.sdkInt.toString(), 'Android'];
  }

  IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
  String device = await CommonUtils.getDeviceInfo();
  return [iosDeviceInfo.systemVersion, device];
}

/// 全局label
class GlobalLabel extends StatefulWidget {
  final String version;
  final String deviceInfo;
  final String platform;
  final String language;

  GlobalLabel({this.version, this.deviceInfo, this.platform, this.language});

  @override
  _GlobalLabelState createState() => _GlobalLabelState();
}

class _GlobalLabelState extends State<GlobalLabel> {
  bool doubleClick = false;
  bool longClick = false;

  @override
  void dispose() {
    DebugLabel.hadShow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Material(
            color: Colors.transparent,
            child: Container(
              child: InkWell(
                onLongPress: () => longClick = true,
                onDoubleTap: () {
                  doubleClick = true;
                  if (longClick && doubleClick) {
                    NavigatorUtils.pushDebugDataPage(context);
                  }
                },
                child: Text(
                  '${widget.platform} ${widget.deviceInfo} ${widget.language} ${widget.language}',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            ),
          ),
          alignment: Alignment(0.97, 0.8),
        );
      },
    );
  }
}
