import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/router.dart';
import 'package:flutter_pro_cli_test/styles/text_styles.dart';

/// 帖子下面的信息栏
///
/// 包括用户头像、昵称和评论信息，但不包括点赞，因为点赞为动态组件
/// 需要参数[uid]、[nickname]、[headerImage]、[commentNum]
class ArticleBottomBar extends StatelessWidget {
  /// 用户id
  final String uid;

  /// 用户昵称
  final String nickname;

  /// 用户头像
  final String avatar;

  /// 评论数
  final int commentNum;

  /// 构造函数
  const ArticleBottomBar(
      {Key key, this.uid, this.nickname, this.avatar, this.commentNum})
      : super(key: key);

  /// 帖子栏中的用户头像和昵称信息
  Widget getUserWidget(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () =>
          Router().open(context, "tyfapp://userpageguest?userId=${uid}"),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              avatar,
              width: 28.0,
              height: 28.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          Text(
            nickname,
            style: TextStyles.commonStyle(0.8),
          )
        ],
      ),
    );
  }

  /// 帖子栏中的评论信息
  Widget getCommentWidget() {
    return Row(
      children: [
        Icon(
          Icons.comment,
          color: Colors.grey,
          size: 18.0,
        ),
        Padding(padding: EdgeInsets.only(left: 10)),
        Text(
          '$commentNum',
          style: TextStyles.commonStyle(0.8),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 8,
          child: getUserWidget(context),
        ),
        Expanded(
          flex: 2,
          child: getCommentWidget(),
        )
      ],
    );
  }
}
