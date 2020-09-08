import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/styles/text_styles.dart';

/// 具体的贴子标题
///
/// [title]为帖子详情标题
class ArticleDetailTitle extends StatelessWidget {
  /// 帖子标题
  final String title;

  /// 构造函数
  const ArticleDetailTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          this.title,
          softWrap: true,
          style: TextStyles.commonStyle(1.2),
        ),
      ),
    );
  }
}
