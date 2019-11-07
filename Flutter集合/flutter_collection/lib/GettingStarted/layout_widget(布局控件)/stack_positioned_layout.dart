import 'package:flutter/material.dart';

// 层叠布局
// Stack 允许子组件堆叠，而 Positioned 用于根据 Stack 的四个角来确定子组件的
class StackAndPositionedLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stack和绝对定位'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center, // 指定未定位或部分定位widget的对齐方式
          fit: StackFit.expand, // 未定位widget占满Stack整个空间
          children: <Widget>[
            Container(
              child: Text(
                'Hello World',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            ),
            Positioned(
              left: 18.0,
              child: Text('This is Flutter Learn Demo'),
            ),
            Positioned(
              top: 18.0,
              child: Text('Do you started learn?'),
            ),
          ],
        ),
      ),
    );
  }
}
