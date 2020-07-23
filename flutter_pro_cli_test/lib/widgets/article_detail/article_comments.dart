import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/util/struct/comment_info.dart';

/// 具体的评论内容信息
///
/// [commentList]为帖子的评论列表
class ArticleComments extends StatelessWidget {
  /// 传入的评论信息
  final List<StructCommentInfo> commentList;

  const ArticleComments({Key key, this.commentList}) : super(key: key);

  /// 获取单行的评论展示信息
  ///
  /// 包括展示评论内容，以及评论者头像和昵称
  Widget getOneItemSection(StructCommentInfo commentItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              commentItem.userInfo.avatar,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commentItem.userInfo.nickname,
                style: TextStyles.commonStyle(),
              ),
              Text(
                commentItem.comment,
                style: TextStyles.commonStyle(.8),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return getOneItemSection(this.commentList[position]);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: .5,
          color: Color(0xFFDDDDDD),
        );
      },
      itemCount: this.commentList.length,
    );
  }
}
