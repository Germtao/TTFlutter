import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/article_card.dart';

/// 首页
class HomePageIndex extends StatefulWidget {
  /// 构造函数
  const HomePageIndex();

  @override
  _HomePageIndexState createState() => _HomePageIndexState();
}

/// 首页具体的state类
class _HomePageIndexState extends State<HomePageIndex> {
  /// 首页推荐帖子列表
  List<StructContentDetail> contentList;

  @override
  void initState() {
    super.initState();
    // 拉取推荐内容
    setState(() {
      contentList = ApiContentIndex().getRecommendList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return ArticleCard(articleInfo: this.contentList[position]);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: .5,
          color: Color(0xFFDDDDDD),
        );
      },
      itemCount: contentList.length,
    );
  }
}
