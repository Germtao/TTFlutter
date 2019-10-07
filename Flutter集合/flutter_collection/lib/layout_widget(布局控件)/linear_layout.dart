import 'package:flutter/material.dart';

// 线性布局
class LinearLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('线性布局'),
      ),
      body: Column(
        // 测试 Row 对齐方式, 排除 Column 默认居中对齐的干扰
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Row 主轴居中对齐'),
              Text('Row 主轴居中对齐啊'),
            ],
          ),
        ],
      ),
    );
  }
}
