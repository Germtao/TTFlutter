import 'package:flutter/material.dart';

// SingleChildScrollView类似于Android中的ScrollView，它只能接收一个子组件
/*
SingleChildScrollView({
  this.scrollDirection = Axis.vertical, //滚动方向，默认是垂直方向
  this.reverse = false, // 是否按照阅读方向相反的方向滑动
  this.padding, 
  bool primary, 
  this.physics, 
  this.controller,
  this.child,
})
 */

// 通常SingleChildScrollView只应在期望的内容不会超过屏幕太多时使用，
// 这是因为SingleChildScrollView不支持基于Sliver的延迟实例化模型，
// 所以如果预计视口可能包含超出屏幕尺寸太多的内容时，那么使用SingleChildScrollView将会非常昂贵（性能差），
// 此时应该使用一些支持Sliver延迟加载的可滚动组件，如ListView

// 下面是一个将大写字母A-Z沿垂直方向显示的例子，由于垂直方向空间会超过屏幕视口高度，所以我们使用SingleChildScrollView
class SingleChildScrollViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Scaffold(
      appBar: AppBar(
        title: Text('SingleChildScrollView'),
      ),
      // 显示进度条
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              // 动态创建一个List<Widget>
              children: str
                  .split('')
                  .map((c) => Text(c, textScaleFactor: 2.0))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
