import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/widget/pull/nested/nested_refresh.dart';
import 'package:flutter_github_app/widget/pull/pull_load_old_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 通用上下拉刷新控件
class NestedPullLoadWidget extends StatefulWidget {
  /// item 渲染
  final IndexedWidgetBuilder itemBuilder;

  /// 下拉刷新回调
  final RefreshCallback onRefresh;

  /// 上拉加载更多回调
  final RefreshCallback onLoadMore;

  /// 控制器，比如数据和一些配置
  final PullLoadOldWidgetControl control;

  final Key refreshKey;

  final NestedScrollViewHeaderSliversBuilder headerSliversBuilder;

  final ScrollController scrollController;

  NestedPullLoadWidget(
    this.control,
    this.itemBuilder,
    this.onRefresh,
    this.onLoadMore, {
    this.refreshKey,
    this.headerSliversBuilder,
    this.scrollController,
  });

  @override
  _NestedPullLoadWidgetState createState() => _NestedPullLoadWidgetState();
}

class _NestedPullLoadWidgetState extends State<NestedPullLoadWidget> {
  @override
  void initState() {
    super.initState();
  }

  /// 根据配置状态返回实际列表数量
  /// 实际上这里可以根据你的需要做更多的处理
  /// 比如多个头部，是否需要空页面，是否需要显示加载更多。
  _getListCount() {
    /// 是否需要头部
    if (widget.control.needHeader) {
      /// 如果需要头部，用Item 0 的 Widget 作为ListView的头部
      /// 列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (widget.control.dataList.length > 0)
          ? widget.control.dataList.length + 2
          : widget.control.dataList.length + 1;
    } else {
      /// 如果不需要头部，在没有数据时，固定返回数量1用于空页面呈现
      if (widget.control.dataList.length == 0) {
        return 1;
      }

      /// 如果有数据,因为部加载更多选项，需要对列表数据总数+1
      return (widget.control.dataList.length > 0) ? widget.control.dataList.length + 1 : widget.control.dataList.length;
    }
  }

  /// 根据配置状态返回实际列表渲染Item
  _renderItem(int index) {
    if (!widget.control.needHeader && index == widget.control.dataList.length && widget.control.dataList.length != 0) {
      /// 如果不需要头部，并且数据不为0，且index == 数据长度，渲染加载更多item（因为index从0开始）
      return _buildProgressIndicator();
    } else if (widget.control.needHeader && index == _getListCount() - 1 && widget.control.dataList.length != 0) {
      /// 如果需要头部，并且数据不为0，且index == 实际渲染长度 - 1，渲染加载更多item（因为index从0开始）
      return _buildProgressIndicator();
    } else if (!widget.control.needHeader && widget.control.dataList.length == 0) {
      /// 如果不需要头部，且数据为0，渲染空页面
      return _buildEmpty();
    } else {
      /// 回调外部正常渲染item，如果这里需要，可以直接返回相应位置的index
      return widget.itemBuilder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewRefreshIndicator(
      /// GlobalKey，用户外部获取 RefreshIndicator 的 State，做显示刷新
      key: widget.refreshKey,
      child: NestedScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: widget.headerSliversBuilder,
        body: NotificationListener(
          onNotification: (ScrollNotification noti) {
            if (noti.metrics.pixels >= noti.metrics.maxScrollExtent) {
              if (widget.control.needLoadMore.value) {
                widget.onLoadMore?.call();
              }
            }
            return false;
          },
          child: ListView.builder(
            itemCount: _getListCount(),
            itemBuilder: (BuildContext context, int index) {
              return _renderItem(index);
            },
          ),
        ),
      ),

      /// 下拉刷新触发，返回一个 Future
      onRefresh: widget.onRefresh,
    );
  }

  /// 构建 空页面
  Widget _buildEmpty() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {},
            child: Image(
              image: AssetImage(TTIcons.DEFAULT_USER_ICON),
              width: 70.0,
              height: 70.0,
            ),
          ),
          Container(
            child: Text(
              TTLocalizations.i18n(context).appEmpty,
              style: TTConstant.normalText,
            ),
          )
        ],
      ),
    );
  }

  /// 构建 上拉加载更多
  Widget _buildProgressIndicator() {
    /// 是否需要显示上拉加载更多的loading
    Widget bottomWidget = (widget.control.needLoadMore.value)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// loading框
              SpinKitRotatingCircle(
                color: Theme.of(context).primaryColor,
              ),
              Container(
                width: 5.0,
              ),

              /// 加载中文本
              Text(
                TTLocalizations.i18n(context).loadMoreText,
                style: TextStyle(
                  color: Color(0xFF121917),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )

        /// 不需要加载
        : Container();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: bottomWidget,
      ),
    );
  }
}
