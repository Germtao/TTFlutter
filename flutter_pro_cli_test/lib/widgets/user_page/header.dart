import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/model/user_info_model.dart';

class UserPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userInfoModel = Provider.of<UserInfoModel>(context);

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
                    userInfoModel.value.avatar,
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  userInfoModel.value.nickname,
                  style: TextStyles.commonStyle(),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: Colors.lightBlueAccent,
                  size: 30,
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 20)),
        ],
      ),
    );
  }
}
