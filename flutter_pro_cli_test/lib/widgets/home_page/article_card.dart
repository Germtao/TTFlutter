import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/router.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

import 'package:flutter_pro_cli_test/widgets/home_page/article_summary.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/article_like_bar.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/article_bottom_bar.dart';

/// 此为帖子描述类，包括了帖子UI中的所有元素
class ArticleCard extends StatelessWidget {
  /// 传入的帖子信息
  final StructContentDetail articleInfo;

  const ArticleCard({Key key, this.articleInfo}) : super(key: key);

  void goToArticleDetailPage(BuildContext context, String articleId) {
    Router().open(context, 'tyfapp://contentpage?articleId=${articleId}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: FlatButton(
        onPressed: () => goToArticleDetailPage(context, articleInfo.id),
        child: Column(
          children: [
            ArticleSummary(
              title: articleInfo.title,
              summary: articleInfo.summary,
              articleImage: articleInfo.articleImage,
            ),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: ArticleBottomBar(
                    nickname: articleInfo.userInfo.nickName,
                    avatar: articleInfo.userInfo.headerUrl,
                    commentNum: articleInfo.commentNum,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ArticleLikeBar(
                    articleId: articleInfo.id,
                    likeNum: articleInfo.likeNum,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
