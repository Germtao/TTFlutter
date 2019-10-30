import 'package:flutter/material.dart';

// SizedBox用于给子元素指定固定的宽高
class SizedBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SizedBox'),
      ),
      // body: SizedBox(
      //   width: 200.0,
      //   height: 200.0,
      //   child: redBox,
      // ),
      body: ConstrainedBox(
        // constraints: BoxConstraints.tightFor(width: 200.0, height: 200.0),
        constraints: BoxConstraints(
          minHeight: 200.0,
          maxHeight: 200.0,
          minWidth: 200.0,
          maxWidth: 200.0,
        ),
        child: redBox,
      ),
    );
  }

  // 定义一个redBox，它是一个背景颜色为红色的盒子，不指定它的宽度和高度
  Widget redBox = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
  );
}
