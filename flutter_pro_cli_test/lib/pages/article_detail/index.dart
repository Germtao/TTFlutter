import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/tools/json_config.dart';
import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_comments.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_content.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_detail_like.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

class ArticleDetailIndex extends StatelessWidget {
  final String articleId;

  const ArticleDetailIndex({Key key, this.articleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String id = articleId;

    if (articleId == null &&
        ModalRoute.of(context).settings.arguments != null) {
      Map dataInfo =
          JsonConfig.objectToMap(ModalRoute.of(context).settings.arguments);
      id = dataInfo['articleId'].toString();
    }

    if (id == null) {
      return Text('error');
    }

    StructContentDetail articleInfo = ApiContentIndex().getOneById(id);

    return Column(
      children: [
        ArticleContent(content: articleInfo.detailInfo),
        ArticleDetailLike(articleId: id, likeNum: articleInfo.likeNum),
        ArticleComments(commentList: [])
      ],
    );
  }
}
