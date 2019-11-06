import 'package:flutter/material.dart';

// 颜色和主题
class NavBarTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('颜色和主题'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 背景为蓝色，则title自动为白色
            NavBar(
              color: Colors.blue,
              title: '标题',
            ),

            NavBar(
              color: Colors.white,
              title: '标题',
            )
          ],
        ),
      ),
    );
  }
}

// 导航栏NavBar的简单实现
class NavBar extends StatelessWidget {
  final String title;
  final Color color; // 背景色

  NavBar({
    Key key,
    this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 52.0,
        minWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          // 阴影
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          // 根据背景色亮度来确定title颜色
          // computeLuminance() 数字越大颜色越浅
          color: color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
        ),
      ),
      alignment: Alignment.center,
    );
  }
}
