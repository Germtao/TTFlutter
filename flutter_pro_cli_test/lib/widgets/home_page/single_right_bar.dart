import 'package:flutter/material.dart';
import 'package:flutter_pro_cli_test/styles/text_styles.dart';

/// 帖子下面的信息栏
///
/// 包括用户头像、昵称和评论信息，但不包括点赞，因为点赞为动态组件
/// 需要参数[nickname]、[avatar]、[commentNum]
class SingleRightBar extends StatelessWidget {
  final String nickname;
  final String avatar;
  final int commentNum;

  const SingleRightBar({Key key, this.nickname, this.avatar, this.commentNum})
      : super(key: key);

  /// 帖子栏中的用户昵称和头像组件
  Widget getUserWidget() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            this.avatar,
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 30))
      ],
    );
  }

  /// 帖子栏中的评论信息
  Widget getCommentWidget() {
    return Column(
      children: [
        Icon(Icons.comment, color: Colors.grey, size: 35),
        Padding(padding: EdgeInsets.only(top: 2)),
        Text(
          '$commentNum',
          style: TextStyles.commonStyle(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(padding: EdgeInsets.only(top: 300)),
        getUserWidget(),
        getCommentWidget(),
      ],
    );
  }
}
