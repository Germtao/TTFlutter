import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/// 主题 Redux
/// 通过 redux 的 combineReducers，实现 Reducer 方法
// ignore: non_constant_identifier_names
final ThemeDataReducer = combineReducers<ThemeData>([
  // 将 Action 、处理 Action 的方法、State 绑定
  TypedReducer<ThemeData, RefreshThemeDataAction>(_refresh),
]);

/// 定义处理 Action 行为的方法，返回新的 State
ThemeData _refresh(ThemeData themeData, action) {
  themeData = action.themeData;
  return themeData;
}

/// 定义一个 Action 类
/// 将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshThemeDataAction {
  final ThemeData themeData;

  RefreshThemeDataAction(this.themeData);
}
