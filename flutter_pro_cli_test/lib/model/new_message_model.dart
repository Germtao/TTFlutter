import 'package:flutter/material.dart';

/// 新消息 状态管理模块
class NewMessageModel with ChangeNotifier {
  /// 未读新消息数
  int newMessageNum;

  /// 构造函数
  NewMessageModel({this.newMessageNum});

  /// 获取未读消息数
  int get value => newMessageNum;

  /// 设置已阅读新消息
  void readNewMessage() {
    if (newMessageNum == 0) {
      return;
    }

    newMessageNum = 0;
    notifyListeners();
  }

  /// 接口异步返回重新通知
  void setNewMessageNum(int unReadNum) {
    if (unReadNum == null || unReadNum == 0) {
      return;
    }

    newMessageNum = unReadNum;
    notifyListeners();
  }
}
