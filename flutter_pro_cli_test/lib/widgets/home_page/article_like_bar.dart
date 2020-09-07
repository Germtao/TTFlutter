import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/model/like_num_model.dart';

/// 帖子文章的赞组件
///
/// 包括点赞组件 icon ，以及组件点击效果
/// 需要外部参数[articleId]、[likeNum],点赞数量
class ArticleLikeBar extends StatelessWidget {
  /// 帖子 id
  final String articleId;

  /// 点赞数
  final int likeNum;

  /// 构造函数
  const ArticleLikeBar({Key key, this.articleId, this.likeNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likeNumModel = Provider.of<LikeNumModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          child: Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.grey, size: 18.0),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                '${likeNumModel.getLikeNum(articleId, likeNum)}',
                style: TextStyles.commonStyle(0.8),
              )
            ],
          ),
          onPressed: () => likeNumModel.like(articleId),
        )
      ],
    );
  }
}
