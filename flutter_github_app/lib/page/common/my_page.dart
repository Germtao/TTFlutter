import 'package:flutter/material.dart';
import 'package:flutter_github_app/page/user/base_person_state.dart';

/// 主页我的tab页面
class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends BasePersonState<MyPage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
