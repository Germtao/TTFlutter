import 'package:flutter/material.dart';

/// 提交信息详情页面
class PushDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String sha;
  final bool needHomeIcon;

  PushDetailPage(this.sha, this.userName, this.reposName, {this.needHomeIcon = false});

  @override
  _PushDetailPageState createState() => _PushDetailPageState();
}

class _PushDetailPageState extends State<PushDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
