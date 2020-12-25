import 'package:flutter/material.dart';

/// 仓库详情
class RepositoryDetailPage extends StatefulWidget {
  /// 用户名
  final String username;

  /// 仓库名
  final String reposname;

  RepositoryDetailPage(this.username, this.reposname);

  @override
  _RepositoryDetailPageState createState() => _RepositoryDetailPageState();
}

class _RepositoryDetailPageState extends State<RepositoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
