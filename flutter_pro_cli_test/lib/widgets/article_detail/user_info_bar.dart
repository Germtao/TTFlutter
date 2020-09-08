import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/router.dart';
import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

/// 具体的帖子 用户信息 bar
///
/// [userInfo] 为帖子详情 用户信息
class ArticleDetailUserInfoBar extends StatelessWidget {
  /// 用户信息
  final StructUserInfo userInfo;

  /// 构造函数
  const ArticleDetailUserInfoBar({Key key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () => Router().open(
                  context, "tyfapp://userpageguest?userId=${userInfo.uid}"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      userInfo.headerUrl,
                      width: 28.0,
                      height: 28.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    userInfo.nickName,
                    style: TextStyles.commonStyle(0.8, Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.grey,
                ),
                Padding(padding: EdgeInsets.only(left: 5)),
                Text(
                  '123',
                  style: TextStyles.commonStyle(0.8, Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
