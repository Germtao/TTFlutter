import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/model/new_message_model.dart';
import 'package:flutter_pro_cli_test/widgets/common/red_badge.dart';

class UserPageButtonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newMessageModel = Provider.of<NewMessageModel>(context);

    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person_pin),
          title: Text('我的好友'),
          onTap: () {},
        ),
        ListTile(
          leading: CommonRedBadge.showRedBadge(
            Icon(Icons.email),
            newMessageModel.value,
            hasNum: true,
          ),
          title: Text('我的消息'),
          onTap: () {
            newMessageModel.readNewMessage();
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('我的设置'),
          onTap: () {},
        ),
      ],
    );
  }
}
