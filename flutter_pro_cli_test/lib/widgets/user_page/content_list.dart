import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/widgets/common/error.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/article_card.dart';
import 'package:flutter_pro_cli_test/widgets/common/loading.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

/// 用户界面 帖子列表
///
/// 需要外部参数 [id]
class UserPageContentList extends StatefulWidget {
  /// 用户id
  final String id;

  /// 构造函数
  const UserPageContentList({Key key, this.id}) : super(key: key);

  @override
  _UserPageContentListState createState() => _UserPageContentListState();
}

class _UserPageContentListState extends State<UserPageContentList> {
  /// 帖子列表
  List<StructContentDetail> contentList;

  /// 列表事件监听
  ScrollController scrollController = ScrollController();

  /// 是否有更多
  bool hasMore;

  /// 是否正在加载
  bool isLoading;

  /// 最后一个数据 id
  String lastId;

  /// 是否接口报错
  bool error = false;

  /// 处理首次拉取和刷新数据获取动作
  void setFirstPage() {
    ApiContentIndex.getUserContentList(widget.id).then((retInfo) {
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

  /// 处理刷新操作
  Future onRefresh() {
    return Future.delayed(Duration(seconds: 1), () {
      setFirstPage();
    });
  }

  /// 加载更多
  void loadMoreData() {
    ApiContentIndex.getUserContentList(widget.id, lastId).then((retInfo) {
      if (retInfo.ret != 0) {
        return;
      }

      List<StructContentDetail> newList = retInfo.data;

      setState(() {
        error = false;
        hasMore = retInfo.hasMore;
        isLoading = false;
        contentList.addAll(newList);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    /// 拉取首页接口数据
    setFirstPage();

    /// 监听滑动事件
    this.scrollController.addListener(() {
      if (!hasMore) {
        return;
      }

      if (!isLoading &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        isLoading = true;
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.scrollController.dispose();
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
      onRefresh: onRefresh,
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        shrinkWrap: true,
        itemCount: contentList.length + 1,
        itemBuilder: (context, position) {
          if (position < this.contentList.length) {
            return ArticleCard(articleInfo: contentList[position]);
          }

          return CommonLoadingButton(loadingState: isLoading, hasMore: hasMore);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            indent: 75,
            color: Color(0xFFDDDDDD),
          );
        },
      ),
    );
  }
}
