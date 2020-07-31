import 'package:flutter/material.dart';
import 'package:flutter_pro_cli_test/api/user_info/index.dart';
import 'package:flutter_pro_cli_test/api/user_info/message.dart';
import 'package:flutter_pro_cli_test/model/new_message_model.dart';
import 'package:flutter_pro_cli_test/model/user_info_model.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/model/like_num_model.dart';
import 'package:flutter_pro_cli_test/pages/entrance_bottom_bar.dart';
// import 'package:flutter_pro_cli_test/pages/entrance.dart';
import 'package:flutter_pro_cli_test/router.dart';

/// 处理xml测试
import 'api_xml/index.dart';

/// APP 核心入口文件
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final likeNumModel = LikeNumModel();

  @override
  Widget build(BuildContext context) {
    // return Provider<Map<String, int>>.value(
    //   value: {},
    //   child: ChangeNotifierProvider.value(
    //     value: likeNumModel,
    //     child: MaterialApp(
    //       title: 'Two You', // App 名字
    //       debugShowCheckedModeBanner: false,
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue, // App 主题
    //       ),
    //       routes: Router().registerRouter(),
    //       home: Entrance(),
    //     ),
    //   ),
    // );
    return FutureBuilder<Widget>(
      future: _getProviders(
        context,
        MaterialApp(
          title: 'Two You', // App 名字
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue, // App 主题
          ),
          routes: Router().registerRouter(),
          home: Entrance(),
        ),
      ),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return Container(
          child: snapshot.data,
        );
      },
    );
  }

  /// 部分数据需要获取初始值
  Future<Widget> _getProviders(BuildContext context, Widget child) async {
    StructUserInfo userInfo = await ApiUserInfoIndex.getSelfUserInfo();
    // StructUserInfo userInfo = await ApiXmlUserInfoIndex.getSelfUserInfo();

    if (userInfo == null) {
      return CommonError();
    }

    int unReadMessageNum = ApiUserInfoMessage.getUnreadMessage();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LikeNumModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserInfoModel(userInfo: userInfo),
        ),
        ChangeNotifierProvider(
          create: (context) => NewMessageModel(newMessageNum: unReadMessageNum),
        ),
      ],
      child: child,
    );
  }
}
