import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

/// 用户界面 来访 bar
///
/// 需要的外部参数 [userInfo]
class UserPageGuestBar extends StatelessWidget {
  /// 用户信息
  final StructUserInfo userInfo;

  const UserPageGuestBar({Key key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.local_post_office,
            size: 30,
            color: Colors.lightBlueAccent,
          ),
          Padding(padding: EdgeInsets.only(left: 20)),
          Icon(
            Icons.trending_up,
            size: 30,
            color: Colors.lightBlueAccent,
          ),
          Padding(padding: EdgeInsets.only(left: 5)),
          Text(
            '1234',
            style: TextStyles.commonStyle(1, Colors.lightBlueAccent),
          )
        ],
      ),
    );
  }
}
