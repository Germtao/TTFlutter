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

  /// 展示底部栏
  final bool showBottomBar;

  /// 构造函数
  const ArticleCard({Key key, this.articleInfo, this.showBottomBar})
      : super(key: key);

  /// 执行页面跳转到article_detail
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
            _getBottomBar(),
          ],
        ),
      ),
    );
  }

  /// 判断是否显示底部导航栏
  Widget _getBottomBar() {
    if (showBottomBar == null || !showBottomBar) {
      return Container();
    }

    return Row(
      children: [
        Expanded(
          flex: 9,
          child: ArticleBottomBar(
            uid: articleInfo.userInfo.uid,
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
    );
  }
}
