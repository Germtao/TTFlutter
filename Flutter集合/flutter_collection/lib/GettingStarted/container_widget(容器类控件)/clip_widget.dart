import 'dart:ui';

import 'package:flutter/material.dart';

// ClipOval - 子控件为正方形时剪裁为内贴圆形，为矩形时，剪裁为内贴椭圆
// ClipRRect - 将子控件剪裁为圆角矩形
// ClipRect - 剪裁子控件到实际占用的矩形大小（溢出部分剪裁）
class ClipTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      color: Colors.white,
      child: FlutterLogo(size: 60.0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Clip裁剪'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            avatar, // 不裁剪
            ClipOval(
              child: avatar, // 裁剪为圆形
            ),
            // 裁剪为圆角矩形
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: avatar,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  widthFactor: .5, // 宽度设为原来宽度一半
                  child: avatar,
                ),
                Text('clip test', style: TextStyle(color: Colors.red)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 将溢出的部分剪裁
                ClipRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: .5, // 宽度设为原来宽度一半
                    child: avatar,
                  ),
                ),
                Text('clip test', style: TextStyle(color: Colors.red)),
              ],
            ),

            DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              child: ClipRect(
                clipper: MyClipper(),
                child: avatar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 剪裁是在layout完成后的绘制阶段进行的，所以不会影响组件的大小，这和Transform原理是相似的

// 自定义剪裁
class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(10.0, 15.0, 40.0, 30.0);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
