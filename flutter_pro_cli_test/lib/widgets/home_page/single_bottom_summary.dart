import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/router.dart';
import 'package:flutter_pro_cli_test/styles/text_styles.dart';

/// 帖子概要信息
///
/// 包括帖子的标题，帖子描述和帖子中的图片
/// 需要外部参数 [articleId]、[title]、[summary]
class SingleBottomSummary extends StatelessWidget {
  /// 帖子id
  final String articleId;

  /// 帖子标题
  final String title;

  /// 帖子概要描述信息
  final String summary;

  const SingleBottomSummary({Key key, this.articleId, this.title, this.summary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
          ),
          FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () => Router()
                .open(context, 'tyfapp://contentpage?articleId=${articleId}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.commonStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  summary,
                  style: TextStyles.commonStyle(0.8, Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
