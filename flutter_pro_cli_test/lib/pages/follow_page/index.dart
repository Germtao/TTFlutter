import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/article_card.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';
import 'package:flutter_pro_cli_test/widgets/common/loading.dart';

import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

class FollowPageIndex extends StatefulWidget {
  const FollowPageIndex();

  @override
  _FollowPageIndexState createState() => _FollowPageIndexState();
}

class _FollowPageIndexState extends State<FollowPageIndex> {
  /// 关注列表
  List<StructContentDetail> contentList;
  ScrollController scrollController = ScrollController();
  bool hasMore;
  bool isLoading;
  String lastId;

  bool error = false;

  void setFirstPage() {
    ApiContentIndex.getFollowList().then((retInfo) {
      if (retInfo.ret != 0) {
        error = true;
        return;
      }

      setState(() {
        error = false;
        contentList = retInfo.data;
        hasMore = retInfo.hasMore;
        isLoading = false;
        lastId = retInfo.lastId;
      });
    });
  }

  Future onRefresh() {
    return Future.delayed(Duration(seconds: 1), () {
      setFirstPage();
    });
  }

  void loadMoreData() {
    ApiContentIndex.getFollowList(lastId).then((retInfo) {
      if (retInfo != 0) {
        return;
      }

      List<StructContentDetail> newList = retInfo.data;

      setState(() {
        error = false;
        isLoading = false;
        hasMore = retInfo.hasMore;
        lastId = retInfo.lastId;
        contentList.addAll(newList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      return CommonError();
    }

    if (contentList == null) {
      return Loading();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        shrinkWrap: true,
        itemCount: contentList.length + 1,
        itemBuilder: (context, position) {
          if (position < contentList.length) {
            return ArticleCard(
              articleInfo: contentList[position],
              showBottomBar: true,
            );
          }

          return CommonLoadingButton(
            loadingState: isLoading,
            hasMore: hasMore,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            color: Color(0xFFDDDDDD),
          );
        },
      ),
    );
  }
}
