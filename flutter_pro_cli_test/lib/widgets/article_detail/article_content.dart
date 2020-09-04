import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';

/// 具体的帖子详情，内容模块
///
/// [content]为帖子详情内容
class ArticleDetailContent extends StatelessWidget {
  /// 传入的帖子内容
  final String content;

  const ArticleDetailContent({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        this.content,
        softWrap: true,
        style: TextStyles.commonStyle(1, Colors.black54),
      ),
    );
  }
}
