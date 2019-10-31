import 'package:flutter/material.dart';

// 自定义抽屉效果
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        // removeTop: true, // 移除抽屉菜单顶部默认留白
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: FlutterLogo(
                        size: 80.0,
                      ),
                    ),
                  ),
                  Text(
                    'Flutter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: Text('新增账号'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text('设置'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
