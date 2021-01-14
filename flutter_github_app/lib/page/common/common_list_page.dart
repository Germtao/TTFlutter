import 'package:flutter/material.dart';

import '../../common/dao/repos_dao.dart';
import '../../common/dao/user_dao.dart';
import '../../common/utils/navigator_utils.dart';

/// 通用 list
class CommonListPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String showType;
  final String dataType;
  final String title;

  CommonListPage(
    this.title,
    this.showType,
    this.dataType, {
    this.userName,
    this.reposName,
  });

  @override
  _CommonListPageState createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
