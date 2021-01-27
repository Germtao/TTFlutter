import 'package:flutter/material.dart';

import '../../common/localization/default_localizations.dart';
import '../../common/utils/common_utils.dart';
import '../../common/utils/event_utils.dart';
import '../../common/utils/navigator_utils.dart';
import '../../common/style/style.dart';

import '../../model/event.dart';
import '../../model/repo_commit.dart';
import '../../model/notification.dart' as Model;

import '../../widget/icon/icon_user_widget.dart';
import '../../widget/card/tt_card_item.dart';

/// 事件 item
class EventItem extends StatelessWidget {
  final EventViewModel eventViewModel;
  final VoidCallback onPressed;
  final bool needImage;

  EventItem(
    this.eventViewModel, {
    this.onPressed,
    this.needImage = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget des = (eventViewModel.actionDes == null || eventViewModel.actionDes.length == 0)
        ? Container()
        : Container(
            child: Text(
              eventViewModel.actionDes,
              style: TTConstant.smallSubText,
              maxLines: 3,
            ),
            margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
            alignment: Alignment.topLeft,
          );

    Widget userImage = needImage
        ? UserIconWidget(
            padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 5.0),
            width: 30.0,
            height: 30.0,
            image: eventViewModel.actionUserPic,
            onPressed: () => NavigatorUtils.pushPersonDetailPage(context, eventViewModel.actionUser),
          )
        : Container();

    return Container(
      child: TTCardItem(
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    userImage,
                    Expanded(
                      child: Text(
                        eventViewModel.actionUser,
                        style: TTConstant.smallTextBold,
                      ),
                    ),
                    Text(
                      eventViewModel.actionTime,
                      style: TTConstant.smallSubText,
                    )
                  ],
                ),
                Container(
                  child: Text(
                    eventViewModel.actionTarget,
                    style: TTConstant.smallTextBold,
                  ),
                  margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
                  alignment: Alignment.topLeft,
                ),
                des
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventViewModel {
  String actionUser;
  String actionUserPic;
  String actionDes;
  String actionTime;
  String actionTarget;

  EventViewModel.fromEventMap(Event event) {
    actionTime = CommonUtils.getNewsTimeStr(event.createdAt);
    actionUser = event.actor.login;
    actionUserPic = event.actor.avatarUrl;
    var other = EventUtils.getActionAndDesc(event);
    actionDes = other['desc'];
    actionTarget = other['actionStr'];
  }

  EventViewModel.fromCommitMap(RepoCommit repoCommit) {
    actionTime = CommonUtils.getNewsTimeStr(repoCommit.commit.committer.date);
    actionUser = repoCommit.commit.committer.name;
    actionDes = 'sha:${repoCommit.sha}';
    actionTarget = repoCommit.commit.message;
  }

  EventViewModel.fromNotify(BuildContext context, Model.Notification notify) {
    actionTime = CommonUtils.getNewsTimeStr(notify.updateAt);
    actionUser = notify.repository.fullName;
    String type = notify.subject.type;
    String status =
        notify.unread ? TTLocalizations.i18n(context).notifyUnread : TTLocalizations.i18n(context).notifyReaded;
    actionDes = notify.reason +
        TTLocalizations.i18n(context).notifyType +
        '：$type' +
        TTLocalizations.i18n(context).notifyStatus +
        '：$status';
    actionTarget = notify.subject.title;
  }
}
