import 'package:flutter/material.dart';
import 'package:flutter_lagou_demo/pages/home_page_widget.dart';
import 'pages/test_stateful_widget.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two You', // app 的title信息
      theme: ThemeData(
        primarySwatch: Colors.blue, // 页面的主题颜色
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Two You'),
        ),
        body: Center(
          child: HomePage1(),
        ),
      ),
    );
  }
}
