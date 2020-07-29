import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/tools/json_config.dart';
import 'package:flutter_pro_cli_test/widgets/user_page/button_list.dart';
import 'package:flutter_pro_cli_test/widgets/user_page/header.dart';

class UserPageIndex extends StatelessWidget {
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
