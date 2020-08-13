import 'package:flutter/material.dart';
import 'package:flutter_pro_cli_test/api/user_info/index.dart';
import 'package:flutter_pro_cli_test/api/user_info/message.dart';
import 'package:flutter_pro_cli_test/model/new_message_model.dart';
import 'package:flutter_pro_cli_test/model/user_info_model.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/model/like_num_model.dart';
// import 'package:flutter_pro_cli_test/pages/entrance_bottom_bar.dart';
import 'package:flutter_pro_cli_test/pages/entrance.dart';
import 'package:flutter_pro_cli_test/router.dart';

/// 处理xml测试
import 'api_xml/index.dart';

/// APP 核心入口文件
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    // json 协议
    StructUserInfo userInfo = await ApiUserInfoIndex.getSelfUserInfo();
    // xml 协议
    // StructUserInfo userInfo = await ApiXmlUserInfoIndex.getSelfUserInfo();

    if (userInfo == null) {
      return MaterialApp(
        title: 'Two You', // APP 名字
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue, // APP 主题
        ),
        home: CommonError(),
      );
    }

    // 初始化共享状态对象
    LikeNumModel likeNumModel = LikeNumModel();
    NewMessageModel newMessageModel = NewMessageModel(newMessageNum: 0);

    // 异步数据处理
    ApiUserInfoMessage.getUnreadMessageNum(newMessageModel);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => likeNumModel),
        ChangeNotifierProvider(
          create: (context) => UserInfoModel(userInfo: userInfo),
        ),
        ChangeNotifierProvider(create: (context) => newMessageModel),
      ],
      child: child,
    );
  }
}
