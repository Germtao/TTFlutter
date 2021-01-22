import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:provider/provider.dart';

import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/common/utils/event_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/event.dart';
import 'package:flutter_github_app/model/user.dart';
import 'package:flutter_github_app/model/user_org.dart';
import 'package:flutter_github_app/page/user/widget/user_header.dart';
import 'package:flutter_github_app/page/user/widget/user_item.dart';
import 'package:flutter_github_app/widget/event/event_item.dart';
import 'package:flutter_github_app/widget/pull/nested/nested_refresh.dart';
import 'package:flutter_github_app/widget/pull/nested/sliver_header_delegate.dart';
import 'package:flutter_github_app/widget/pull/state/common_list_state.dart';

abstract class BasePersonState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin<T>, CommonListState<T>, SingleTickerProviderStateMixin {
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshKey =
      GlobalKey<NestedScrollViewRefreshIndicatorState>();

  final List<UserOrg> orgList = List();

  final HonorModel honorModel = HonorModel();

  @override
  showRefreshLoading() {
    Future.delayed(Duration(seconds: 0), () {
      refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  @protected
  renderItem(
    index,
    User user,
    String beStaredCount,
    Color notifyColor,
    VoidCallback refreshCallback,
    List<UserOrg> orgList,
  ) {
    if (user.type == 'Organization') {
      return UserItem(
        UserItemViewModel.fromMap(pullLoadOldWidgetControl.dataList[index]),
        onPressed: () {
          NavigatorUtils.pushPersonDetailPage(
            context,
            UserItemViewModel.fromMap(pullLoadOldWidgetControl.dataList[index]).userName,
          );
        },
      );
    } else {
      Event event = pullLoadOldWidgetControl.dataList[index];
      return EventItem(
        EventViewModel.fromEventMap(event),
        onPressed: () {
          EventUtils.actionUtils(context, event, '');
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @protected
  getUserOrg(String userName) {
    if (page <= 1 && userName != null) {
      UserDao.getUserOrgsDao(userName, page, needDb: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
          return res.next?.call();
        }
        return Future.value(null);
      }).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
        }
      });
    }
  }

  List<Widget> sliverBuilder(
    BuildContext context,
    bool innerBoxIsScrolled,
    User user,
    Color notifyColor,
    String beStaredCount,
    refreshCallback,
  ) {
    double headerSize = 210;
    double bottomSize = 70;
    double chartSize = (user.login != null && user.type == 'Organization') ? 70 : 215;
    return <Widget>[
      /// 头部信息
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
          minHeight: headerSize,
          maxHeight: headerSize,
          changeSize: true,
          vSyncs: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 10),
          ),
          builder: (context, shrinkOffset, overlapsContent) {
            return Transform.translate(
              offset: Offset(0, -shrinkOffset),
              child: SizedBox.expand(
                child: Container(
                  child: UserHeaderItem(
                    user,
                    beStaredCount,
                    Theme.of(context).primaryColor,
                    notifyColor: notifyColor,
                    refreshCallback: refreshCallback,
                    orgList: orgList,
                  ),
                ),
              ),
            );
          },
        ),
      ),

      /// 悬停 item
      SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverHeaderDelegate(
          minHeight: bottomSize,
          maxHeight: bottomSize,
          changeSize: true,
          vSyncs: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 10),
          ),
          builder: (context, shrinkOffset, overlapsContent) {
            var radius = Radius.circular(10 - shrinkOffset / bottomSize * 10);
            return SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10.0),

                /// MultiProvider 共享 HonorModel 状态
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => honorModel,
                    )
                  ],
                  child: Consumer<HonorModel>(
                    builder: (context, honorModel, _) {
                      return UserHeaderBottom(
                        user,
                        honorModel.beStaredCount?.toString() ?? '---',
                        radius,
                        honorModel.honorList,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),

      /// 提交图表
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          minHeight: chartSize,
          maxHeight: chartSize,
          changeSize: true,
          vSyncs: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 10),
          ),
          builder: (context, shrinkOffset, overlapsContent) {
            return SizedBox.expand(
              child: Container(
                height: chartSize,
                child: UserHeaderChart(user),
              ),
            );
          },
        ),
      )
    ];
  }

  /// 获取用户仓库前100个star统计数据
  getHonor(userName) {
    ReposDao.getUserRepository100StatusDao(userName).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          // 提交到  Provider  HonorMode
          honorModel.beStaredCount = res.data['stared'];
          honorModel.honorList = res.data['list'];
        }
      }
    });
  }
}

/// Provider HonorModel
class HonorModel extends ChangeNotifier {
  int _beStaredCount;

  int get beStaredCount => _beStaredCount;

  set beStaredCount(int value) {
    _beStaredCount = value;
    notifyListeners();
  }

  List _honorList;

  List get honorList => _honorList;

  set honorList(List value) {
    _honorList = value;
    notifyListeners();
  }
}
