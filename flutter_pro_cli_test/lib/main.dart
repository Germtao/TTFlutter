import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/model/like_num_model.dart';
import 'package:flutter_pro_cli_test/pages/entrance_bottom_bar.dart';
// import 'package:flutter_pro_cli_test/pages/entrance.dart';
import 'package:flutter_pro_cli_test/router.dart';

/// APP 核心入口文件
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final likeNumModel = LikeNumModel();

  @override
  Widget build(BuildContext context) {
    return Provider<Map<String, int>>.value(
      value: {},
      child: ChangeNotifierProvider.value(
        value: likeNumModel,
        child: MaterialApp(
          title: 'Two You', // App 名字
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue, // App 主题
          ),
          routes: Router().registerRouter(),
          home: Entrance(),
        ),
      ),
    );
  }
}
