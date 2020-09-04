import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/article_card.dart';
import 'package:flutter_pro_cli_test/widgets/common/loading.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';

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

  /// 列表事件监听
  ScrollController scrollController = ScrollController();

  /// 是否有更多
  bool hasMore;

  /// 页面是否正在加载...
  bool isLoading;

  /// 最后一个数据 id
  String lastId;

  /// 是否接口报错
  bool error = false;

  /// 处理首次拉取和刷新数据获取动作
  void setFirstPage() {
    print('122');
    ApiContentIndex.getRecommendList().then((retInfo) {
      if (retInfo.ret != 0) {
        // 判断返回是否正确
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

  /// 加载更多数据
  void loadMoreData() {
    print('加载更多数据');
    ApiContentIndex.getRecommendList(lastId).then((retInfo) {
      if (retInfo.ret != 0) {
        return;
      }

      List<StructContentDetail> newList = retInfo.data;

      setState(() {
        error = false;
        isLoading = false;
        hasMore = retInfo.hasMore;
        contentList.addAll(newList);
      });
    });
  }

  /// 处理刷新操作
  Future onRefresh() {
    return Future.delayed(Duration(seconds: 1), () {
      setFirstPage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 拉取首页接口数据
    setFirstPage();

    // 监听上滑事件，活动加载更多
    this.scrollController.addListener(() {
      if (!hasMore) {
        return;
      }

      if (!isLoading &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        isLoading = true;
        // 加载更多数据
        loadMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      return CommonError(action: this.setFirstPage);
    }

    if (contentList == null) {
      return Loading();
    }

    return RefreshIndicator(
      onRefresh: onRefresh, // 调用刷新事件
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        shrinkWrap: true,
        itemCount: contentList.length + 1,
        itemBuilder: (context, position) {
          if (position < this.contentList.length) {
            return ArticleCard(
              articleInfo: this.contentList[position],
              showBottomBar: true,
            );
          }
          return CommonLoadingButton(loadingState: isLoading, hasMore: hasMore);
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
