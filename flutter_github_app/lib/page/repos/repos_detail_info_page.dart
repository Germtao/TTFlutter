import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/event_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/repo_commit.dart';
import 'package:flutter_github_app/page/repos/scope/repos_detail_model.dart';
import 'package:flutter_github_app/page/repos/widget/repos_header_item.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_github_app/widget/common/select_item_widget.dart';
import 'package:flutter_github_app/widget/event/event_item.dart';
import 'package:flutter_github_app/widget/pull/nested/nested_pull_load_widget.dart';
import 'package:flutter_github_app/widget/pull/nested/nested_refresh.dart';
import 'package:flutter_github_app/widget/pull/nested/sliver_header_delegate.dart';
import 'package:flutter_github_app/widget/pull/state/common_list_state.dart';
import 'package:flutter_github_app/widget/text/icon_text.dart';
import 'package:scoped_model/scoped_model.dart';

/// 仓库详情动态信息页面
class ReposDetailInfoPage extends StatefulWidget {
  final String userName;

  final String reposName;

  ReposDetailInfoPage(this.userName, this.reposName, {Key key}) : super(key: key);

  @override
  ReposDetailInfoPageState createState() => ReposDetailInfoPageState();
}

/// 页面 KeepAlive ，同时支持 动画Ticker
class ReposDetailInfoPageState extends State<ReposDetailInfoPage>
    with
        AutomaticKeepAliveClientMixin<ReposDetailInfoPage>,
        CommonListState<ReposDetailInfoPage>,
        TickerProviderStateMixin {
  /// 滑动监听
  final ScrollController scrollController = ScrollController();

  /// 当前显示 tab
  int selectIndex = 0;

  /// 初始化 header 默认大小，后面动态调整
  double headerSize = 270;

  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshKey = GlobalKey();

  /// 动画控制器
  AnimationController animationController;

  /// 绘制 时间item和提交item
  _renderEventItem(index) {
    var item = pullLoadOldWidgetControl.dataList[index];
    if (selectIndex == 1 && item is RepoCommit) {
      return EventItem(
        EventViewModel.fromCommitMap(item),
        onPressed: () {
          RepoCommit repoCommit = pullLoadOldWidgetControl.dataList[index];
          NavigatorUtils.pushPushDetailPage(
            context,
            widget.userName,
            widget.reposName,
            repoCommit.sha,
            false,
          );
        },
      );
    }
    return EventItem(
      EventViewModel.fromEventMap(pullLoadOldWidgetControl.dataList[index]),
      onPressed: () {
        EventUtils.actionUtils(
          context,
          pullLoadOldWidgetControl.dataList[index],
          widget.userName + '/' + widget.reposName,
        );
      },
    );
  }

  /// 绘制内置Header，支持部分停靠支持
  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      /// 头部信息
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          maxHeight: headerSize,
          minHeight: headerSize,
          vSyncs: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            duration: const Duration(milliseconds: 10),
            curve: Curves.bounceInOut,
          ),
          child: ReposHeaderItem(
            ReposHeaderViewModel.fromHttpMap(
              widget.userName,
              widget.reposName,
              ReposDetailModel.of(context).repositoryQL,
            ),
            layoutListener: (size) {
              setState(() {
                headerSize = size.height;
              });
            },
          ),
        ),
      ),

      /// 动态放大缩小的 tab 控件
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
            minHeight: 60.0,
            maxHeight: 60.0,
            changeSize: true,
            vSyncs: this,
            snapConfig: FloatingHeaderSnapConfiguration(
              duration: const Duration(milliseconds: 10),
              curve: Curves.bounceInOut,
            ),
            builder: (context, shrinkOffset, overlapsContent) {
              /// 根据数值计算偏差
              var lr = 10 - shrinkOffset / 60 * 10;
              var radius = Radius.circular(4 - shrinkOffset / 60 * 4);
              return SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(left: lr, right: lr, bottom: 10),
                  child: SelectItemWidget(
                    [
                      TTLocalizations.i18n(context).reposTabActivity,
                      TTLocalizations.i18n(context).reposTabCommits,
                    ],
                    (index) {
                      /// 切换时，先滚动
                      scrollController
                          .animateTo(
                        0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut,
                      )
                          .then((_) {
                        selectIndex = index;
                        clearData();
                        showRefreshLoading();
                      });
                    },
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(radius),
                    ),
                  ),
                ),
              );
            }),
      )
    ];
  }

  /// 绘制 底部状态 item
  _renderBottomItem(String text, IconData iconData, onPressed) {
    return FlatButton(
      onPressed: onPressed,
      child: TTIconText(
        text,
        iconData,
        TTConstant.smallText,
        TTColors.primaryValue,
        15.0,
        padding: 5.0,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  /// 绘制 底部状态控件
  List<Widget> _renderBottomWidget() {
    /// 根据网络返回数据，返回底部状态数据
    List<Widget> bottomWidget = (ReposDetailModel.of(context).bottomStatusModel == null)
        ? []
        : <Widget>[
            /// Star
            _renderBottomItem(
              ReposDetailModel.of(context).bottomStatusModel.starText,
              ReposDetailModel.of(context).bottomStatusModel.starIcon,
              () {
                CommonUtils.showLoadingDialog(context);
                return ReposDao.starRepositoryDao(
                  widget.userName,
                  widget.reposName,
                  ReposDetailModel.of(context).repositoryQL.isStared,
                ).then((res) {
                  showRefreshLoading();
                  Navigator.pop(context);
                });
              },
            ),

            /// Watch
            _renderBottomItem(
              ReposDetailModel.of(context).bottomStatusModel.watchText,
              ReposDetailModel.of(context).bottomStatusModel.watchIcon,
              () {
                CommonUtils.showLoadingDialog(context);
                return ReposDao.watchRepositoryDao(
                  widget.userName,
                  widget.reposName,
                  ReposDetailModel.of(context).repositoryQL.isSubscription == 'SUBSCRIBED',
                ).then((res) {
                  showRefreshLoading();
                  Navigator.of(context).pop();
                });
              },
            ),

            /// fork
            _renderBottomItem('fork', TTIcons.REPOS_ITEM_FORK, () {
              CommonUtils.showLoadingDialog(context);
              return ReposDao.createForkDao(widget.userName, widget.reposName).then((res) {
                showRefreshLoading();
                Navigator.pop(context);
              });
            })
          ];
    return bottomWidget;
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScopedModelDescendant<ReposDetailModel>(
      builder: (context, child, model) {
        return NestedPullLoadWidget(
          pullLoadOldWidgetControl,
          (context, index) => _renderEventItem(index),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshKey,
          scrollController: scrollController,
          headerSliversBuilder: (context, _) {
            return _sliverBuilder(context, _);
          },
        );
      },
    );
  }

  /// 获取 数据列表
  _getDataLogic() async {
    if (selectIndex == 1) {
      return await ReposDao.getRepositoryCommitsDao(
        widget.userName,
        widget.reposName,
        page: page,
        branch: ReposDetailModel.of(context).currentBranch,
        needDb: page <= 1,
      );
    }

    return await ReposDao.getRepositoryEventDao(
      widget.userName,
      widget.reposName,
      page: page,
      branch: ReposDetailModel.of(context).currentBranch,
      needDb: page <= 1,
    );
  }

  /// 获取 仓库详情
  _getReposDetail() {
    ReposDao.getRepositoryDetailDao(
      widget.userName,
      widget.reposName,
      ReposDetailModel.of(context).currentBranch,
    ).then((res) {
      if (res != null && res.result) {
        if (res.data.defaultBranch != null && res.data.defaultBranch.length > 0) {
          ReposDetailModel.of(context).currentBranch = res.data.defaultBranch;
        }

        ReposDetailModel.of(context).repositoryQL = res.data;
        ReposDetailModel.of(context).getRepositoryStatus(_renderBottomWidget);

        if (res.next != null) {
          return res.next();
        }
        return null;
      }
      return new Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (!isShow) return;
      }

      ReposDetailModel.of(context).repositoryQL = res.data;
      ReposDetailModel.of(context).getRepositoryStatus(_renderBottomWidget);
    });
  }

  @override
  showRefreshLoading() {
    Future.delayed(const Duration(seconds: 0), () {
      refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  @override
  requestRefresh() async {
    _getReposDetail();
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;
}
