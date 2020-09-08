import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/util/tools/json_config.dart';
import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_comments.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_content.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_detail_like.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/article_img.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/widgets/article_detail/user_info_bar.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';

/// 帖子详情页面
///
/// 需要外部参数 [articleId]
class ArticleDetailIndex extends StatelessWidget {
  /// 帖子id
  final String articleId;

  /// 构造函数
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

    return FutureBuilder<Widget>(
      future: _getWidget(id),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return Container(
          child: snapshot.data,
        );
      },
    );
  }

  Future<Widget> _getWidget(String id) async {
    StructContentDetail contentDetail = await ApiContentIndex.getOneById(id);

    if (contentDetail == null) {
      return CommonError();
    }

    return Scaffold(
      appBar: AppBar(title: Text(contentDetail.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ArticleDetailUserInfoBar(userInfo: contentDetail.userInfo),
            Padding(padding: EdgeInsets.only(top: 2)),
            ArticleDetailContent(content: contentDetail.detailInfo),
            ArticleDetailImg(articleImage: contentDetail.articleImage),
            ArticleDetailLike(articleId: id, likeNum: contentDetail.likeNum),
            ArticleDetailComments(commentList: []),
          ],
        ),
      ),
    );
  }
}
