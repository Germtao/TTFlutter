import 'package:flutter/material.dart';

// 填充控件
// Padding可以给其子节点添加填充（留白），和边距效果类似
class PaddingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('填充'),
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0), // 上下左右各添加50像素留白
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 指定对齐方式为左对齐，排除对齐干扰
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // 左边添加15像素留白
              child: Text('Hello World'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0), // 上下各添加5像素留白
              child: Text('I am an apple'),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20.0, 20.0, .0, 20.0), // 四个方向各指定留白
              child: Text('U are a pen'),
            )
          ],
        ),
      ),
    );
  }
}
