import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/page/user/widget/user_item.dart';
import 'package:flutter_github_app/widget/pull/pull_load_old_widget.dart';
import 'package:flutter_github_app/widget/pull/state/common_list_state.dart';

class TrendUserPage extends StatefulWidget {
  @override
  _TrendUserPageState createState() => _TrendUserPageState();
}

class _TrendUserPageState extends State<TrendUserPage>
    with AutomaticKeepAliveClientMixin<TrendUserPage>, CommonListState<TrendUserPage> {
  String endCursor;

  /// 绘制 item
  _renderItem(index) {
    if (pullLoadOldWidgetControl.dataList.length == 0) {
      return null;
    }
    var data = pullLoadOldWidgetControl.dataList[index];
    return UserItem(
      UserItemViewModel.fromQL(data, index + 1),
      onPressed: () => NavigatorUtils.pushPersonDetailPage(context, data.login),
    );
  }

  _getDataLogic() async {
    return await UserDao.searchTrendUserDao(
      'China',
      cursor: endCursor,
      valueChanged: (endCursor) {
        this.endCursor = endCursor;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TTLocalizations.i18n(context).trendUserTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PullLoadOldWidget(
        pullLoadOldWidgetControl,
        (context, index) => _renderItem(index),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;
}
