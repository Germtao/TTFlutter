import 'package:flutter/material.dart';

/// router 配置数据结构
class RouterStruct {
  /// 组件
  final Widget widget;

  /// 首页入口 index
  final int entranceIndex;

  /// 组件参数列表
  final List<String> params;

  const RouterStruct(this.widget, this.entranceIndex, this.params);
}
