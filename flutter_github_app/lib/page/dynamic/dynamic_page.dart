import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../redux/state.dart';
import '../../model/event.dart';

import 'dynamic_bloc.dart';
import '../../common/dao/repos_dao.dart';
import '../../common/utils/event_utils.dart';

import '../../widget/event/event_item.dart';
import '../../widget/pull/pull_load_widget.dart';

/// 主页动态页面
class DynamicPage extends StatefulWidget {
  DynamicPage({Key key}) : super(key: key);

  @override
  DynamicPageState createState() => DynamicPageState();
}

/// 主页动态页面
class DynamicPageState extends State<DynamicPage>
    with AutomaticKeepAliveClientMixin<DynamicPage>, WidgetsBindingObserver {
  final DynamicBloc dynamicBloc = DynamicBloc();

  /// 控制列表滚动和监听
  final ScrollController scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  bool _ignoring = true;

  /// 模拟 iOS 下拉刷新
  showRefreshLoading() {
    // 直接触发下拉刷新
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollController
          .animateTo(
        -141,
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
      )
          .then((_) {
        // setState(() {
        //   _ignoring = false;
        // });
      });
      return true;
    });
  }

  scrollToTop() {
    if (scrollController.offset <= 0) {
      scrollController
          .animateTo(
            0,
            duration: Duration(milliseconds: 600),
            curve: Curves.linear,
          )
          .then((_) => showRefreshLoading);
    } else {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
      );
    }
  }

  /// 下拉刷新数据
  Future<void> requestRefresh() async {
    await dynamicBloc.requestRefresh(_getStore().state.userInfo?.login).catchError((e) {
      print('dynamic page refresh error: $e');
    });
    setState(() {
      _ignoring = false;
    });
  }

  /// 上拉加载更多数据
  Future<void> requestLoadMore() async {
    return await dynamicBloc.requestLoadMore(_getStore().state.userInfo?.login);
  }

  /// 渲染事件 item
  _renderEventItem(Event event) {
    EventViewModel eventViewModel = EventViewModel.fromEventMap(event);
    return EventItem(
      eventViewModel,
      onPressed: () => EventUtils.actionUtils(context, event, ''),
    );
  }

  @override
  void initState() {
    super.initState();

    // 监听生命周期，主要判断页面 resumed 的时候触发刷新
    WidgetsBinding.instance.addObserver(this);

    // 获取新版本信息
    ReposDao.getNewsVersion(context, false);
  }

  @override
  void didChangeDependencies() {
    // 请求更新
    if (dynamicBloc.getDataLength() == 0) {
      dynamicBloc.changeNeedHeaderStatus(false);

      // 先读取数据库
      dynamicBloc.requestRefresh(_getStore().state.userInfo?.login, doNextFlag: false).then((_) {
        showRefreshLoading();
      });
    }
    super.didChangeDependencies();
  }

  /// 监听生命周期，主要判断页面 resumed 的时候触发刷新
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (dynamicBloc.getDataLength() != 0) {
        showRefreshLoading();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    dynamicBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // See AutomaticKeepAliveClientMixin.
    super.build(context);
    var content = PullLoadWidget(
      dynamicBloc.pullLoadWidgetControl,
      (context, index) => _renderEventItem(dynamicBloc.dataList[index]),
      requestRefresh,
      requestLoadMore,
      refreshKey: refreshIndicatorKey,
      scrollController: scrollController,
      useIOS: true,
    );
    return IgnorePointer(
      ignoring: _ignoring,
      child: content,
    );
  }

  @override
  bool get wantKeepAlive => true;

  Store<TTState> _getStore() {
    return StoreProvider.of(context);
  }
}
