import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/page/repos/widget/repos_item.dart';

/// 荣耀 列表页面
class HonorListPage extends StatefulWidget {
  final List list;

  HonorListPage(this.list);

  @override
  _HonorListPageState createState() => _HonorListPageState();
}

class _HonorListPageState extends State<HonorListPage> {
  /// 绘制 item
  _renderItem(item) {
    ReposViewModel reposViewModel = ReposViewModel.fromMap(item);
    return ReposItem(
      reposViewModel,
      onPressed: () => NavigatorUtils.pushReposDetailPage(
        context,
        reposViewModel.ownerName,
        reposViewModel.repositoryName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TTLocalizations.i18n(context).userTabHonor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _renderItem(widget.list[index]);
        },
        itemCount: widget.list.length,
      ),
    );
  }
}
