import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/single_bottom_summary.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/single_right_bar.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/single_like_bar.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

/// 单个内容首页
class HomePageSingle extends StatefulWidget {
  HomePageSingle({Key key}) : super(key: key);

  @override
  HomePageSingleState createState() => HomePageSingleState();
}

class HomePageSingleState extends State<HomePageSingle> {
  int indexPos;
  List<StructContentDetail> contentList;

  @override
  void initState() {
    super.initState();

    indexPos = 0;
    // 拉取推荐内容
    setState(() {
      contentList = ApiContentIndex().getRecommendList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(contentList[indexPos].articleImage),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleRightBar(
            nickname: contentList[indexPos].userInfo.nickname,
            avatar: contentList[indexPos].userInfo.avatar,
            commentNum: contentList[indexPos].commentNum,
          ),
          SingleLikeBar(
            articleId: contentList[indexPos].id,
            likeNum: contentList[indexPos].likeNum,
          ),
          SingleBottomSummary(
            articleId: contentList[indexPos].id,
            title: contentList[indexPos].title,
            summary: contentList[indexPos].summary,
          )
        ],
      ),
    );
  }
}
