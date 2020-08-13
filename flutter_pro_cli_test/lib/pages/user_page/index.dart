import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/widgets/user_page/button_list.dart';
import 'package:flutter_pro_cli_test/widgets/user_page/header.dart';

/// 用户页面
class UserPageIndex extends StatelessWidget {
  /// 构造函数
  const UserPageIndex();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserPageHeader(),
        Expanded(
          child: UserPageButtonList(),
        )
      ],
    );
  }
}
