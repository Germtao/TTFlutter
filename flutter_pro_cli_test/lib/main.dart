import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/pages/entrance_bottom_bar.dart';
// import 'package:flutter_pro_cli_test/pages/entrance.dart';
import 'package:flutter_pro_cli_test/router.dart';

/// APP 核心入口文件
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two You', // App 名字
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // App 主题
      ),
      routes: Router().registerRouter(),
      home: Entrance(),
    );
  }
}
