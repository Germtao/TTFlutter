import 'package:flutter/material.dart';

/// 仓库详情
class RepositoryDetailPage extends StatefulWidget {
  /// 用户名
  final String userName;

  /// 仓库名
  final String reposName;

  RepositoryDetailPage(this.userName, this.reposName);

  @override
  _RepositoryDetailPageState createState() => _RepositoryDetailPageState();
}

class _RepositoryDetailPageState extends State<RepositoryDetailPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// 底部状态实体
class BottomStatusModel {
  final String watchText;
  final String starText;
  final IconData watchIcon;
  final IconData starIcon;

  BottomStatusModel(this.watchText, this.starText, this.watchIcon, this.starIcon);
}
