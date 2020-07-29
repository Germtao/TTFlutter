import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

/// 通用的红点逻辑
class CommonRedBadge {
  /// 展示消息红点
  static Widget showRedBadge(Widget needRedWidget, int newMessageNum,
      {bool hasNum = false}) {
    if (newMessageNum < 1) {
      return needRedWidget; // 小于1的消息则无需设置
    }

    if (!hasNum) {
      return _getBadge(needRedWidget, '');
    } else {
      String msgTips = newMessageNum > 99 ? '99+' : '$newMessageNum';
      return _getBadge(needRedWidget, msgTips);
    }
  }

  /// 获取badge组件
  static Widget _getBadge(Widget needRedWidget, String msgTips) {
    return Badge(
      alignment: Alignment.bottomLeft,
      position: BadgePosition.topRight(),
      toAnimate: false,
      badgeContent: Text(
        '$msgTips',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          letterSpacing: 1,
          wordSpacing: 2,
          height: 1,
        ),
      ),
    );
  }
}
