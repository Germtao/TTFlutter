import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';

/// 帖子概要信息
///
/// 包括帖子的标题，帖子描述和帖子中的图片
class ArticleSummary extends StatelessWidget {
  /// 帖子标题
  final String title;

  /// 帖子概要描述信息
  final String summary;

  /// 帖子中的图片信息
  final String articleImage;

  const ArticleSummary({Key key, this.title, this.summary, this.articleImage})
      : super(key: key);

  /// 左侧的标题和标题描述组件
  Widget getLeftInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.commonStyle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          summary,
          style: TextStyles.commonStyle(0.8, Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: getLeftInfo(),
        ),
        Expanded(
          flex: 2,
          child: Image.network(
            articleImage,
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
