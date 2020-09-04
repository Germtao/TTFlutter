import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

class UserPageGuestHeader extends StatelessWidget {
  /// 用户信息
  final StructUserInfo userInfo;

  const UserPageGuestHeader({Key key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    userInfo.headerUrl,
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  userInfo.nickName,
                  style: TextStyles.commonStyle(),
                ),
                Padding(padding: EdgeInsets.only(bottom: 120.0))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.lightBlueAccent,
                  size: 30,
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 20.0)),
        ],
      ),
    );
  }
}
