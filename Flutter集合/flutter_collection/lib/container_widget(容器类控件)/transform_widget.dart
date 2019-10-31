import 'dart:math' as math;

import 'package:flutter/material.dart';

// Transform 可以在其子组件绘制时对其应用一些矩阵变换来实现一些特效
class TransformWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transform'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            matrix4,
            translate,
            rotate,
            scale,
            example,
            rotatedBox,
          ],
        ),
      ),
    );
  }

  // Matrix4是一个4D矩阵
  Widget matrix4 = Container(
    color: Colors.black,
    child: Transform(
      alignment: Alignment.topRight, // 相对于坐标系原点的对齐方式
      transform: Matrix4.skewY(0.3), // 沿Y轴倾斜0.3弧度
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.deepOrange,
        child: Text('公寓出租'),
      ),
    ),
  );

  // 平移
  Widget translate = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
    // 默认原点为左上角，左移20像素，向上平移5像素
    child: Transform.translate(
      offset: Offset(-20.0, -5.0),
      child: Text(
        'hello world',
        style: TextStyle(color: Colors.black),
      ),
    ),
  );

  // 旋转
  Widget rotate = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
    child: Transform.rotate(
      angle: math.pi / 2,
      child: Text(
        'hello world',
        style: TextStyle(color: Colors.black),
      ),
    ),
  );

  // 缩放
  Widget scale = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
    child: Transform.scale(
      scale: 1.5,
      child: Text(
        'Hello World',
        style: TextStyle(color: Colors.black),
      ),
    ),
  );

  // Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段
  Widget example = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      DecoratedBox(
        decoration: BoxDecoration(color: Colors.red),
        child: Transform.scale(
          scale: 1.5,
          child: Text(
            'Hello World',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Text(
        '你好',
        style: TextStyle(color: Colors.cyan),
      ),
    ],
  );

  // RotatedBox 类似Transform.rotate
  Widget rotatedBox = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      DecoratedBox(
        decoration: BoxDecoration(color: Colors.red),
        child: RotatedBox(
          quarterTurns: 1, // 旋转90度(1/4圈)
          child: Text(
            'Hello World',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Text(
        '你好',
        style: TextStyle(color: Colors.cyan),
      ),
    ],
  );
}
