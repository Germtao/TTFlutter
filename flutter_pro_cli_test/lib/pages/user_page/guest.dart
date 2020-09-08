import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/user_info/index.dart';
import 'package:flutter_pro_cli_test/util/tools/json_config.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';
import 'package:flutter_pro_cli_test/widgets/user_page/content_list.dart';
import 'package:flutter_pro_cli_test/widgets/user_page/guest_bar.dart';
import 'package:flutter_pro_cli_test/widgets/user_page/guest_header.dart';

/// 用户页面 访客
class UserPageGuest extends StatelessWidget {
  /// 用户id
  final String userId;

  /// 构造函数
  const UserPageGuest({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String id = userId;
    if (userId == null && ModalRoute.of(context).settings.arguments != null) {
      Map dataInfo =
          JsonConfig.objectToMap(ModalRoute.of(context).settings.arguments);
      id = dataInfo['userId'].toString();
    }

    return FutureBuilder<Widget>(
        future: _getWidget(id),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          return Container(
            child: snapshot.data,
          );
        });
  }

  Future<Widget> _getWidget(String id) async {
    StructUserInfo userInfo = await ApiUserInfoIndex.getOneById(id);

    if (userInfo == null) {
      return CommonError();
    }

    return Container(
      child: Column(
        children: [
          UserPageGuestHeader(userInfo: userInfo),
          Divider(
            height: 1.0,
            indent: 10,
            endIndent: 10,
            color: Colors.lightBlueAccent,
          ),
          UserPageGuestBar(userInfo: userInfo),
          Expanded(
            child: UserPageContentList(id: id),
          ),
        ],
      ),
    );
  }
}
