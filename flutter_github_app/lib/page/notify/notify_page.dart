import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/widget/common/select_item_widget.dart';
import 'package:flutter_github_app/widget/event/event_item.dart';
import 'package:flutter_github_app/widget/pull/pull_load_old_widget.dart';
import 'package:flutter_github_app/widget/pull/state/common_list_state.dart';
import 'package:flutter_github_app/widget/tab_bar/title_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../model/notification.dart' as Model;

/// 通知消息页面
class NotifyPage extends StatefulWidget {
  NotifyPage();

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage>
    with AutomaticKeepAliveClientMixin<NotifyPage>, CommonListState<NotifyPage> {
  final SlidableController slidableController = SlidableController();

  int selectIndex = 0;

  /// 绘制 item
  _renderItem(index) {
    Model.Notification notification = pullLoadOldWidgetControl.dataList[index];
    if (selectIndex != 0) {
      return _renderEventItem(notification);
    }

    /// 只有未读消息支持 Slidable 侧滑效果
    return Slidable(
      key: ValueKey<String>(index.toString() + '_' + selectIndex.toString()),
      controller: slidableController,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: _renderEventItem(notification),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {},
      ),
      secondaryActions: [
        IconSlideAction(
          caption: TTLocalizations.i18n(context).notifyReaded,
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () {
            UserDao.setNotificationAsReadDao(notification.id.toString()).then((res) {
              showRefreshLoading();
            });
          },
        )
      ],
    );
  }

  /// 绘制实际的内容数据item
  _renderEventItem(Model.Notification notification) {
    EventViewModel eventViewModel = EventViewModel.fromNotify(context, notification);
    return EventItem(
      eventViewModel,
      onPressed: () {
        if (notification.unread) {
          UserDao.setNotificationAsReadDao(notification.id.toString());
        }
        if (notification.subject.type == 'Issue') {
          String url = notification.subject.url;
          List<String> tmpList = url.split('/');
          String number = tmpList[tmpList.length - 1];
          String userName = notification.repository.owner.login;
          String reposName = notification.repository.name;
          NavigatorUtils.pushIssueDetailPage(
            context,
            userName,
            reposName,
            number,
            needRightLocalIcon: true,
          ).then((res) {
            showRefreshLoading();
          });
        }
      },
      needImage: false,
    );
  }

  /// 切换 tab
  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await UserDao.getNotifyDao(selectIndex == 2, selectIndex == 1, page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: TTColors.mainBackgroundColor,
      appBar: AppBar(
        title: TitleBar(
          TTLocalizations.i18n(context).notifyTitle,
          iconData: TTIcons.NOTIFY_ALL_READ,
          needRightLocalIcon: true,
          onRightIconPressed: (_) {
            CommonUtils.showLoadingDialog(context);
            UserDao.setAllNotificationAsReadDao().then((res) {
              Navigator.pop(context);
              _resolveSelectIndex();
            });
          },
        ),
        bottom: SelectItemWidget(
          [
            TTLocalizations.i18n(context).notifyTabUnread,
            TTLocalizations.i18n(context).notifyTabPart,
            TTLocalizations.i18n(context).notifyTabAll
          ],
          (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          },
          height: 30.0,
          margin: const EdgeInsets.all(0.0),
          elevation: 0.0,
        ),
        elevation: 4.0,
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
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }
}
