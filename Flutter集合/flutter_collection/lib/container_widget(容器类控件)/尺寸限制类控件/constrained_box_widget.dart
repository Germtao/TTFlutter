import 'package:flutter/material.dart';

// ConstrainedBox 用于对子组件添加额外的约束
class ConstrainedBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConstrainedBox'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity, // 宽尽可能大
          minHeight: 50.0, // 最小高度50像素
        ),
        child: Container(
          height: 5.0, // minHeight生效，height在此无效
          child: redBox,
        ),
      ),
    );
  }

  // 定义一个redBox，它是一个背景颜色为红色的盒子，不指定它的宽度和高度
  Widget redBox = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
  );
}
