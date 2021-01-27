import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/model/trending_repo.dart';
import 'package:flutter_github_app/page/trend/trend_user_page.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_github_app/widget/pull/nested/sliver_header_delegate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/page/repos/repos_detail_page.dart';
import 'package:flutter_github_app/page/repos/widget/repos_item.dart';
import 'package:flutter_github_app/page/trend/trend_bloc.dart';
import 'package:flutter_github_app/widget/pull/nested/nested_refresh.dart';

/// 主页趋势页面
/// 目前采用 [bloc] 的 [rxdart(stream)] + [streamBuilder]
class TrendPage extends StatefulWidget {
  TrendPage({Key key}) : super(key: key);

  @override
  TrendPageState createState() => TrendPageState();
}

class TrendPageState extends State<TrendPage>
    with AutomaticKeepAliveClientMixin<TrendPage>, SingleTickerProviderStateMixin {
  /// 显示数据时间
  TrendTypeModel selectTime;
  int selectTimeIndex = 0;

  /// 显示过滤语言
  TrendTypeModel selectType;
  int selectTypeIndex = 0;

  /// NestedScrollView 的刷新状态 GlobalKey ，方便主动刷新使
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<NestedScrollViewRefreshIndicatorState>();

  /// 滚动控制和监听
  final ScrollController scrollController = ScrollController();

  /// bloc
  final TrendBloc trendBloc = TrendBloc();

  /// 显示刷新
  _showRefreshLoading() async {
    Future.delayed(Duration(seconds: 0), () {
      refreshIndicatorKey.currentState.show().then((e) {});
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
          .then((_) {
        _showRefreshLoading();
      });
    } else {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
      );
    }
  }

  /// 绘制 item
  _renderItem(e) {
    ReposViewModel reposViewModel = ReposViewModel.fromTrendMap(e);
    return OpenContainer(
      closedColor: Colors.transparent,
      closedElevation: 0,
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) {
        return NavigatorUtils.pageContainer(
          RepositoryDetailPage(
            reposViewModel.ownerName,
            reposViewModel.repositoryName,
          ),
          context,
        );
      },
      tappable: true,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return ReposItem(
          reposViewModel,
          onPressed: null,
        );
      },
    );
  }

  /// 绘制 头部可选弹出item
  _renderHeaderPopItemChild(List<TrendTypeModel> items) {
    List<PopupMenuEntry<TrendTypeModel>> list = List();
    for (TrendTypeModel item in items) {
      list.add(PopupMenuItem<TrendTypeModel>(
        value: item,
        child: Text(item.name),
      ));
    }
    return list;
  }

  /// 绘制 头部可选弹出item容器
  _renderHeaderPopItem(
    String data,
    List<TrendTypeModel> list,
    PopupMenuItemSelected<TrendTypeModel> onSelected,
  ) {
    return Expanded(
      child: PopupMenuButton<TrendTypeModel>(
        child: Center(
          child: Text(
            data,
            style: TTConstant.middleTextWhite,
          ),
        ),
        onSelected: onSelected,
        itemBuilder: (context) {
          return _renderHeaderPopItemChild(list);
        },
      ),
    );
  }

  /// 绘制 头部可选item
  _renderHeader(Store<TTState> store, Radius radius) {
    if (selectTime == null && selectType == null) {
      return Container();
    }
    var trendTimeList = trendTime(context);
    var trendTypeList = trendType(context);

    return TTCardItem(
      color: store.state.themeData.primaryColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(radius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        child: Row(
          children: [
            _renderHeaderPopItem(selectTime.name, trendTimeList, (result) {
              if (trendBloc.isLoading) {
                Fluttertoast.showToast(msg: TTLocalizations.i18n(context).loadingText);
                return;
              }
              scrollController
                  .animateTo(
                0,
                duration: Duration(milliseconds: 200),
                curve: Curves.bounceInOut,
              )
                  .then((_) {
                setState(() {
                  selectTime = result;
                  selectTimeIndex = trendTimeList.indexOf(result);
                });
                _showRefreshLoading();
              });
            }),
            Container(height: 10.0, width: 0.5, color: TTColors.white),
            _renderHeaderPopItem(selectType.name, trendTypeList, (result) {
              if (trendBloc.isLoading) {
                Fluttertoast.showToast(msg: TTLocalizations.i18n(context).loadingText);
                return;
              }
              scrollController
                  .animateTo(
                0,
                duration: Duration(milliseconds: 200),
                curve: Curves.bounceInOut,
              )
                  .then((_) {
                setState(() {
                  selectType = result;
                  selectTypeIndex = trendTypeList.indexOf(result);
                });
                _showRefreshLoading();
              });
            })
          ],
        ),
      ),
    );
  }

  Future<void> requestRefresh() async {
    return trendBloc.requestRefresh(selectTime, selectType);
  }

  @override
  void didChangeDependencies() {
    if (!trendBloc.requested) {
      setState(() {
        selectTime = trendTime(context)[0];
        selectType = trendType(context)[0];
      });
      _showRefreshLoading();
    } else {
      if (selectTimeIndex >= 0) {
        selectTime = trendTime(context)[selectTimeIndex];
      }
      if (selectTypeIndex >= 0) {
        selectType = trendType(context)[selectTypeIndex];
      }
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return StoreBuilder<TTState>(
      builder: (context, store) {
        return Scaffold(
          backgroundColor: TTColors.mainBackgroundColor,
          // 采用目前采用纯 bloc 的 rxdart(stream) + streamBuilder
          body: StreamBuilder<List<TrendingRepo>>(
            stream: trendBloc.stream,
            builder: (context, snapShot) {
              // 下拉刷新
              return NestedScrollViewRefreshIndicator(
                key: refreshIndicatorKey,
                // 嵌套滚动
                child: NestedScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return _sliverBuilder(context, innerBoxIsScrolled, store);
                  },
                  body: (snapShot.data == null || snapShot.data.length == 0)
                      ? _buildEmpty()
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: snapShot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _renderItem(snapShot.data[index]);
                          },
                        ),
                ),
                onRefresh: requestRefresh,
              );
            },
          ),
          floatingActionButton: trendUserButton(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  trendUserButton() {
    final double size = 56.0;
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) {
        return NavigatorUtils.pageContainer(TrendUserPage(), context);
      },
      closedElevation: 6.0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
      ),
      closedColor: Theme.of(context).colorScheme.secondary,
      closedBuilder: (context, openContainer) {
        return SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        );
      },
    );
  }

  /// 嵌套可滚动头部
  List<Widget> _sliverBuilder(
    BuildContext context,
    bool innerBoxIsScrolled,
    Store store,
  ) {
    return <Widget>[
      // 动态头部
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
          maxHeight: 65.0,
          minHeight: 65.0,
          changeSize: true,
          vSyncs: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 10),
          ),
          builder: (context, shrinkOffset, overlapsContent) {
            // 根据数值计算偏差
            var lr = 10 - shrinkOffset / 65 * 10;
            var radius = Radius.circular(4 - shrinkOffset / 65 * 4);
            return SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.only(left: lr, top: lr, right: lr, bottom: 15),
                child: _renderHeader(store, radius),
              ),
            );
          },
        ),
      ),
    ];
  }

  /// 空页面
  Widget _buildEmpty() {
    var statusBar = MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top;
    var bottomArea = MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.bottom;
    var height =
        MediaQuery.of(context).size.height - statusBar - bottomArea - kBottomNavigationBarHeight - kToolbarHeight;
    return SingleChildScrollView(
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
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
      ),
    );
  }
}

/// 趋势数据过滤显示item
class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}

/// 趋势数据时间过滤
List<TrendTypeModel> trendTime(BuildContext context) {
  return [
    TrendTypeModel(TTLocalizations.i18n(context).trendDay, 'daily'),
    TrendTypeModel(TTLocalizations.i18n(context).trendWeek, 'weekly'),
    TrendTypeModel(TTLocalizations.i18n(context).trendMonth, 'monthly'),
  ];
}

/// 趋势数据语言过滤
List<TrendTypeModel> trendType(BuildContext context) {
  return [
    TrendTypeModel(TTLocalizations.i18n(context).trendAll, null),
    TrendTypeModel("Java", "Java"),
    TrendTypeModel("Kotlin", "Kotlin"),
    TrendTypeModel("Dart", "Dart"),
    TrendTypeModel("Objective-C", "Objective-C"),
    TrendTypeModel("Swift", "Swift"),
    TrendTypeModel("JavaScript", "JavaScript"),
    TrendTypeModel("PHP", "PHP"),
    TrendTypeModel("Go", "Go"),
    TrendTypeModel("C++", "C++"),
    TrendTypeModel("C", "C"),
    TrendTypeModel("HTML", "HTML"),
    TrendTypeModel("CSS", "CSS"),
    TrendTypeModel("Python", "Python"),
    TrendTypeModel("C#", "c%23"),
  ];
}
