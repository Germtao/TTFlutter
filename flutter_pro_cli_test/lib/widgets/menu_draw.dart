import 'package:flutter/material.dart';

import '../router.dart';

/// 左侧侧滑菜单
class MenuDraw extends StatelessWidget {
  /// 外部跳转
  final Function redirect;

  /// 构造函数
  const MenuDraw(this.redirect);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('图片流'),
              onTap: () {
                Navigator.pop(context);
                redirect('tyfapp://imgflow');
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('单图片信息'),
              onTap: () {
                Navigator.pop(context);
                Router().open(context, 'tyfapp://singlepage');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('我'),
              onTap: () {
                Navigator.pop(context);
                redirect('tyfapp://userpageguest?userId=1004');
              },
            )
          ],
        ),
      ),
    );
  }
}
