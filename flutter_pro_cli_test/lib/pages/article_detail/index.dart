import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/tools/json_config.dart';
import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_comments.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_content.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_detail_like.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

class ArticleDetailIndex extends StatelessWidget {
  /// 帖子id
  final String articleId;

  const ArticleDetailIndex({Key key, this.articleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String id = articleId;
    StructContentDetail _articleInfo = null;

    if (articleId == null &&
        ModalRoute.of(context).settings.arguments != null) {
      Map dataInfo =
          JsonConfig.objectToMap(ModalRoute.of(context).settings.arguments);
      id = dataInfo['articleId'].toString();
    }

    if (id == null) {
      return Text('error');
    }

    ApiContentIndex().getOneById(id).then((value) {
      _articleInfo = value;
    });

    return Column(
      children: [
        ArticleContent(content: _articleInfo.detailInfo),
        ArticleDetailLike(articleId: id, likeNum: _articleInfo.likeNum),
        ArticleComments(commentList: [])
      ],
    );
  }
}
