import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';
import 'package:flutter_pro_cli_test/model/like_num_model.dart';

/// 帖子文章的赞组件
///
/// 包括点赞组件 icon ，以及组件点击效果
/// 需要外部参数[likeNum],点赞数量
/// [articleId] 帖子的内容
class SingleLikeBar extends StatelessWidget {
  final String articleId;
  final int likeNum;

  const SingleLikeBar({Key key, this.articleId, this.likeNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likeNumModel = Provider.of<LikeNumModel>(context);

    return Container(
      width: 50,
      child: FlatButton(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Icon(Icons.thumb_up, color: Colors.grey, size: 36),
            Padding(padding: EdgeInsets.only(top: 2)),
            Text(
              '${likeNumModel.getLikeNum(articleId, likeNum)}',
              style: TextStyles.commonStyle(),
            )
          ],
        ),
        onPressed: () => likeNumModel.like(articleId),
      ),
    );
  }
}
