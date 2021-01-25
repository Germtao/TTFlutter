import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/event_dao.dart';
import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/redux/user_redux.dart';
import 'package:flutter_github_app/widget/pull/nested/nested_pull_load_widget.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/page/user/base_person_state.dart';

/// 主页我的tab页面
class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends BasePersonState<MyPage> {
  final ScrollController scrollController = ScrollController();

  String beStaredCount = '---';

  Color notifyColor = TTColors.subTextColor;

  Store<TTState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of(context);
  }

  /// 从全局状态中获取用户名
  _getUserName() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    return _getStore()?.state?.userInfo?.login;
  }

  /// 从全局状态中获取用户类型
  _getUserType() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    return _getStore()?.state?.userInfo?.type;
  }

  /// 刷新通知图标颜色
  _refreshNotify() {
    UserDao.getNotifyDao(false, false, 0).then((res) {
      Color newColor;
      if (res != null && res.result && res.data.length > 0) {
        newColor = TTColors.actionBlue;
      } else {
        newColor = TTColors.subLightTextColor;
      }

      if (isShow) {
        setState(() {
          notifyColor = newColor;
        });
      }
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
        showRefreshLoading();
      });
    } else {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
      );
    }
  }

  _getDataLogic() async {
    if (_getUserName() == null) {
      return [];
    }
    if (_getUserType() == 'Organization') {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    return await EventDao.getEventDao(_getUserName(), page: page, needDb: page <= 1);
  }

  @override
  void initState() {
    pullLoadOldWidgetControl.needHeader = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (pullLoadOldWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreBuilder<TTState>(
      builder: (context, store) {
        return NestedPullLoadWidget(
          pullLoadOldWidgetControl,
          (context, index) => renderItem(
            index,
            store.state.userInfo,
            beStaredCount,
            notifyColor,
            () => _refreshNotify(),
            orgList,
          ),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshKey,
          headerSliversBuilder: (context, _) {
            return sliverBuilder(
              context,
              _,
              store.state.userInfo,
              notifyColor,
              beStaredCount,
              () => _refreshNotify(),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  requestRefresh() async {
    if (_getUserName() != null) {
      /*UserDao.getUserInfo(null).then((res) {
        if (res != null && res.result) {
          _getStore()?.dispatch(UpdateUserAction(res.data));
          //todo getUserOrg(_getUserName());
        }
      });*/

      /// 通过 redux 提交更新用户数据行为
      /// 触发网络请求更新
      _getStore().dispatch(FetchUserAction());

      /// 获取用户组织信息
      getUserOrg(_getUserName());

      /// 获取用户仓库前100个star统计数据
      getHonor(_getUserName());

      _refreshNotify();
    }
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }
}
