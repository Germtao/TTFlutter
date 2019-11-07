import 'package:flutter/material.dart';

// 数据共享
// InheritedWidget是Flutter中非常重要的一个功能型组件，
// 它提供了一种数据在widget树中从上到下传递、共享的方式，
// 比如我们在应用的根widget中通过InheritedWidget共享了一个数据，那么我们便可以在任意子widget中来获取该共享的数据
/*
InheritedWidget和React中的context功能类似，和逐级传递数据相比，它们能实现组件跨级传递数据。
InheritedWidget的在widget树中数据传递方向是从上到下的，这和通知Notification（将在下一章中介绍）的传递方向正好相反
 */
class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({@required this.data, Widget child}) : super(child: child);

  final int data; // 需要在子树中共享的数据，保存点击次数

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget of(BuildContext context) {
    // return context.inheritFromWidgetOfExactType(ShareDataWidget);

    // 只想在TestWidgetState中引用ShareDataWidget数据，
    // 但却不希望在ShareDataWidget发生变化时调用TestWidgetState的didChangeDependencies()方法
    return context
        .ancestorInheritedElementForWidgetOfExactType(ShareDataWidget)
        .widget;
  }

  // 该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(ShareDataWidget oldWidget) {
    // 如果返回true，则子树中依赖(build函数中有调用)本widget
    // 的子widget的`state.didChangeDependencies`会被调用
    return oldWidget.data != data;
  }
}
