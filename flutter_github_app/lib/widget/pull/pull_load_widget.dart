import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './pull_load_widget_control.dart';
import './flare_pull_controller.dart';
import './refresh_sliver.dart' as IOS;
import './custom_bouncing_scroll_physics.dart';

const double iOSRefreshHeight = 140;
const double iOSRefreshIndicatorExtent = 100;

/// 通用上下拉刷新控件
class PullLoadWidget extends StatefulWidget {
  /// item 渲染
  final IndexedWidgetBuilder itemBuilder;

  /// 下拉刷新回调
  final RefreshCallback onRefresh;

  /// 加载更多回调
  final RefreshCallback onLoadMore;

  /// 控制器，比如数据和一些配置
  final PullLoadWidgetControl control;

  /// 滚动监听
  final ScrollController scrollController;

  final bool useIOS;

  /// 刷新 key
  final Key refreshKey;

  PullLoadWidget(
    this.control,
    this.itemBuilder,
    this.onRefresh,
    this.onLoadMore, {
    this.refreshKey,
    this.scrollController,
    this.useIOS = false,
  });

  @override
  _PullLoadWidgetState createState() => _PullLoadWidgetState();
}

class _PullLoadWidgetState extends State<PullLoadWidget> with FlarePullController {
  final GlobalKey<IOS.CupertinoSliverRefreshControlState> sliverRefreshKey = GlobalKey();

  ScrollController _scrollController;

  bool isRefreshing = false;

  bool isLoadingMore = false;

  /// 如果正在加载，锁定等待
  _lockToAwait() async {
    doDelayed() async {
      await Future.delayed(Duration(milliseconds: 1000)).then((_) async {
        if (widget.control.isLoading) {
          return await doDelayed();
        } else {
          return null;
        }
      });
    }

    await doDelayed();
  }

  /// 处理下拉刷新
  @protected
  Future<Null> handleRefresh() async {
    if (widget.control.isLoading) {
      if (isRefreshing) return null;

      await _lockToAwait();
    }

    isRefreshing = true;
    widget.control.isLoading = true;
    await widget.onRefresh?.call();
    isRefreshing = false;
    widget.control.isLoading = false;
    return null;
  }

  /// 处理加载更多
  @protected
  Future<Null> handleLoadMore() async {
    if (widget.control.isLoading) {
      if (isLoadingMore) return null;

      await _lockToAwait();
    }

    isLoadingMore = true;
    widget.control.isLoading = true;
    await widget.onLoadMore?.call();
    isLoadingMore = false;
    widget.control.isLoading = false;
    return null;
  }

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    // 增加滑动监听
    _scrollController.addListener(() {
      // 判断当前滑动位置是否到达底部，触发加载更多回调
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (widget.control.needLoadMore) {
          handleLoadMore();
        }
      }
    });

    widget.control.addListener(() {
      setState(() {
        try {
          Future.delayed(Duration(milliseconds: 2000), () {
            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            _scrollController.notifyListeners();
          });
        } catch (e) {
          print(e);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useIOS) {
      return NotificationListener(
        onNotification: (ScrollNotification noti) {
          // 通知 CupertinoSliverRefreshControl 当前的拖拽状态
          sliverRefreshKey.currentState.notifyScrollNotification(noti);
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          // 回弹效果
          physics: const CustomBouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
            refreshHeight: iOSRefreshHeight,
          ),
          slivers: [
            // 控制显示刷新的 CupertinoSliverRefreshControl
            IOS.CupertinoSliverRefreshControl(
              key: sliverRefreshKey,
              refreshIndicatorExtent: iOSRefreshIndicatorExtent,
              refreshTriggerPullDistance: iOSRefreshHeight,
              onRefresh: handleRefresh,
              builder: buildSimpleRefreshIndicator,
            ),
            SliverSafeArea(
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _renderItem(index),
                  childCount: _getListCount(),
                ),
              ),
            )
          ],
        ),
      );
    }
    return RefreshIndicator(
      // GlobalKey，用户外部获取RefreshIndicator的State，做显示刷新
      key: widget.refreshKey,
      onRefresh: handleRefresh,
      child: ListView.builder(
        // 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _getListCount(),
        itemBuilder: (BuildContext context, int index) {
          return _renderItem(index);
        },
      ),
    );
  }

  @override
  ValueNotifier<bool> isActive = ValueNotifier<bool>(true);

  @override
  double get refreshTriggerPullDistance => iOSRefreshHeight;

  @override
  bool get getPlayAuto => playAuto;

  bool playAuto = false;

  Widget buildSimpleRefreshIndicator(
    BuildContext context,
    IOS.RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    pulledExtentFlare = pulledExtent * 0.6;
    playAuto = refreshState == IOS.RefreshIndicatorMode.refresh;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: pulledExtent > iOSRefreshHeight ? pulledExtent : iOSRefreshHeight,
        child: FlareActor(
          'static/file/loading_world_now.flr',
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
          controller: this,
          animation: 'Earth Moving',
        ),
      ),
    );
  }

  /// 根据配置状态返回实际列表数量
  /// 实际上这里可以根据你的需要做更多的处理
  /// 比如多个头部，是否需要空页面，是否需要显示加载更多
  _getListCount() {
    if (widget.control.needHeader) {
      // 如果需要头部，用Item 0 的 Widget 作为ListView的头部
      // 列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (widget.control.dataList.length > 0)
          ? widget.control.dataList.length + 2
          : widget.control.dataList.length + 1;
    } else {
      if (widget.control.dataList.length == 0) {
        return 1;
      }

      // 如果有数据,因为部加载更多选项，需要对列表数据总数+1
      return (widget.control.dataList.length > 0) ? widget.control.dataList.length + 1 : widget.control.dataList.length;
    }
  }

  /// 根据配置状态返回实际列表，渲染item
  _renderItem(int index) {
    if (!widget.control.needHeader && index == widget.control.dataList.length && widget.control.dataList.length != 0) {
      // 如果不需要头部，并且数据不为0，当 index == 数据长度时，渲染加载更多 item（因为index从0开始）
      return _buildProgressIndicator();
    } else if (widget.control.needHeader && index == _getListCount() - 1 && widget.control.dataList.length != 0) {
      // 如果需要头部，并且数据不为0，当index == 实际渲染长度 - 1时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (!widget.control.needHeader && widget.control.dataList.length == 0) {
      // 如果不需要头部，并且数据为0，渲染空页面
      _buildEmpty();
    } else {
      // 回调外部正常渲染Item，如果这里有需要，可以直接返回相对位置的index
      return widget.itemBuilder(context, index);
    }
  }

  /// 构建空页面
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

  /// 构建加载更多的进度条指示器
  Widget _buildProgressIndicator() {
    // 是否需要显示上拉加载更多的loading
    Widget bottomWidget = widget.control.needLoadMore
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 加载框
              SpinKitRotatingCircle(color: Theme.of(context).primaryColor),
              Container(width: 5.0),
              // 加载文本
              Text(
                TTLocalizations.i18n(context).loadMoreText,
                style: TextStyle(
                  color: Color(0xFF121917),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : Container();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: bottomWidget,
      ),
    );
  }
}
