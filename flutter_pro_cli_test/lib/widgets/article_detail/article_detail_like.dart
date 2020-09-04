import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/model/like_num_model.dart';

/// 帖子详情页的赞组件
///
/// 包括点赞组件 icon ，以及组件点击效果
/// 需要外部参数[likeNum]、[articleId]
class ArticleDetailLike extends StatelessWidget {
  /// 帖子 id
  final String articleId;

  /// 点赞数
  final int likeNum;

  const ArticleDetailLike({Key key, this.articleId, this.likeNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likeNumModel = Provider.of<LikeNumModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlatButton(
          child: Icon(
            Icons.thumb_up,
            color: Colors.grey,
            size: 40,
          ),
          onPressed: () => likeNumModel.like(articleId),
        ),
        Text(
          '${likeNumModel.getLikeNum(articleId, likeNum)}',
          style: TextStyles.commonStyle(),
        )
      ],
    );
  }
}
