import 'package:flutter/material.dart';

/// 个人详情页面
class PersonDetailPage extends StatefulWidget {
  static final String className = 'person';

  final String username;

  PersonDetailPage(this.username, {Key key}) : super(key: key);

  @override
  _PersonDetailPageState createState() => _PersonDetailPageState(username);
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  final String username;

  _PersonDetailPageState(this.username);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
