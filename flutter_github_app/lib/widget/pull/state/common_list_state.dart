import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/config/config.dart';
import 'package:flutter_github_app/widget/pull/pull_load_old_widget.dart';

/// 上下拉刷新列表通用State
mixin CommonListState<T extends StatefulWidget> on State<T>, AutomaticKeepAliveClientMixin<T> {
  bool isShow = false;
  bool isLoading = false;
  int page = 1;
  bool isRefreshing = false;
  bool isLoadingMore = false;
  final List dataList = List();
  final PullLoadOldWidgetControl pullLoadOldWidgetControl = PullLoadOldWidgetControl();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    isShow = true;
    super.initState();
    pullLoadOldWidgetControl.needHeader = needHeader;
    pullLoadOldWidgetControl.dataList = getDataList;
    if (pullLoadOldWidgetControl.dataList.length == 0 && isRefreshFirst) {
      showRefreshLoading();
    }
  }

  @override
  void dispose() {
    isShow = false;
    isLoading = false;
    super.dispose();
  }

  _lockToAwait() async {
    doDelayed() async {
      await Future.delayed(Duration(seconds: 1)).then((_) async {
        if (isLoading) {
          return await doDelayed();
        } else {
          return null;
        }
      });
    }

    await doDelayed();
  }

  showRefreshLoading() {
    Future.delayed(Duration(seconds: 0), () {
      refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  @protected
  resolveRefreshResult(res) {
    if (res != null && res.result) {
      pullLoadOldWidgetControl.dataList.clear();
      if (isShow) {
        setState(() {
          pullLoadOldWidgetControl.dataList.addAll(res.data);
        });
      }
    }
  }

  @protected
  resolveDataResult(res) {
    if (isShow) {
      setState(() {
        pullLoadOldWidgetControl.needLoadMore.value =
            (res != null && res.data != null && res.data.length >= Config.PAGE_SIZE);
      });
    }
  }

  @protected
  clearData() {
    if (isShow) {
      setState(() {
        pullLoadOldWidgetControl.dataList.clear();
      });
    }
  }

  @protected
  Future<Null> handleRefresh() async {
    if (isLoading) {
      if (isRefreshing) {
        return null;
      }
      await _lockToAwait();
    }
    isLoading = true;
    isRefreshing = true;
    page = 1;
    var res = await requestRefresh();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next();
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    isRefreshing = false;
    return null;
  }

  @protected
  Future<Null> onLoadMore() async {
    if (isLoading) {
      if (isLoadingMore) {
        return null;
      }
      await _lockToAwait();
    }
    isLoading = true;
    isLoadingMore = true;
    page++;
    var res = await requestLoadMore();
    if (res != null && res.result) {
      if (isShow) {
        setState(() {
          pullLoadOldWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    isLoadingMore = false;
    return null;
  }

  /// 下拉刷新数据
  @protected
  requestRefresh() async {}

  /// 上拉加载更多
  @protected
  requestLoadMore() async {}

  /// 是否需要第一次进入自动刷新
  @protected
  bool get isRefreshFirst;

  /// 是否需要头部
  @protected
  bool get needHeader => false;

  /// 是否需要保持
  @override
  bool get wantKeepAlive => true;

  List get getDataList => dataList;
}
