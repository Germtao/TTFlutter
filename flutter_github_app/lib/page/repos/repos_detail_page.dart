import 'package:flutter/material.dart';
import 'package:flutter_github_app/page/repos/repos_detail_info_page.dart';
import 'package:flutter_github_app/page/repos/repos_file_list_page.dart';

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
  /// 文件列表页的 GlobalKey, 可用于当前控件控制 文件页 行为
  GlobalKey<RepositoryFileListPageState> fileListKey = GlobalKey();

  /// 详情信息页的 GlobalKey, 可用于当前控件控制 详情信息页 行为
  GlobalKey<ReposDetailInfoPageState> infoListKey = GlobalKey();

  

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
