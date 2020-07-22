import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/tools/json_config.dart';

class UserPageIndex extends StatelessWidget {
  /// 用户 id
  final String userId;

  const UserPageIndex({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String myUserId = userId;

    if (ModalRoute.of(context).settings.arguments != null) {
      Map dataInfo =
          JsonConfig.objectToMap(ModalRoute.of(context).settings.arguments);

      myUserId = dataInfo['userId'].toString();
    }

    // TODO: implement build
    return Text('I am user page ${myUserId}');
  }
}
