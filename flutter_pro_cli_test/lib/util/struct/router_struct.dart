import 'package:flutter/material.dart';

/// router 配置数据结构
class RouterStruct {
  /// 组件
  final Widget widget;

  /// 首页入口 index
  final int entranceIndex;

  /// 组件参数列表
  final List<String> params;

  /// 是否需要默认 Scaffold
  final bool needScaffold;

  // ignore: public_member_api_docs
  const RouterStruct(
    this.widget,
    this.entranceIndex,
    this.params,
    this.needScaffold,
  );
}
