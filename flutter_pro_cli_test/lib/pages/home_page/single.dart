import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/common/loading.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/single_bottom_summary.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/single_right_bar.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/single_like_bar.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

/// 单个内容首页
class HomePageSingle extends StatefulWidget {
  /// 构造函数
  const HomePageSingle({Key key}) : super(key: key);

  @override
  HomePageSingleState createState() => HomePageSingleState();
}

class HomePageSingleState extends State<HomePageSingle> {
  /// index position
  int indexPos;

  /// 首页推荐贴子列表
  List<StructContentDetail> contentList;

  @override
  void initState() {
    super.initState();

    indexPos = 0;
    // 拉取推荐内容
    ApiContentIndex.getRecommendList().then((retInfo) {
      if (retInfo.ret != 0) {
        return;
      }

      setState(() {
        contentList = retInfo.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (contentList == null) {
      return Loading();
    }

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
            nickname: contentList[indexPos].userInfo.nickName,
            avatar: contentList[indexPos].userInfo.headerUrl,
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
