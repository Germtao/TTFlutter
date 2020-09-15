import 'package:flutter/material.dart';

/// 使用局部theme强制设置splash color和highlight color为 Colors.transparent
/// [splashColor]: Colors.transparent,
/// [highlightColor]: Colors.transparent),
///
/// [brightness]: Theme.of(context).brightness,确保与appTheme主题一致
class WithOutSplashColorDemo extends StatefulWidget {
  @override
  _WithOutSplashColorDemoState createState() => _WithOutSplashColorDemoState();
}

class _WithOutSplashColorDemoState extends State<WithOutSplashColorDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('去掉点击事件的水波纹效果'),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          brightness: Theme.of(context).brightness,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.description), title: Text('123')),
            BottomNavigationBarItem(icon: Icon(Icons.description), title: Text('123')),
          ],
        ),
      ),
    );
  }
}
