import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/user.dart';
import 'package:flutter_github_app/model/user_org.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_github_app/widget/icon/icon_user_widget.dart';
import 'package:flutter_github_app/widget/text/icon_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

/// 用户详情头部
class UserHeaderItem extends StatelessWidget {
  final User user;
  final String beStaredCount;
  final Color notifyColor;
  final Color themeColor;
  final VoidCallback refreshCallback;
  final List<UserOrg> orgList;

  UserHeaderItem(
    this.user,
    this.beStaredCount,
    this.themeColor, {
    this.notifyColor,
    this.refreshCallback,
    this.orgList,
  });

  /// 绘制 通知icon
  _renderNotifyIcon(BuildContext context, Color color) {
    if (notifyColor == null) {
      return Container();
    }
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.only(left: 5.0, top: 0.0, right: 5.0),
      constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
      child: ClipOval(
        child: Icon(
          TTIcons.USER_NOTIFY,
          color: color,
          size: 18.0,
        ),
      ),
      onPressed: () {
        NavigatorUtils.pushNotifyPage(context).then((res) {
          refreshCallback?.call();
        });
      },
    );
  }

  /// 绘制 用户组织
  _renderUserOrgs(BuildContext context, List<UserOrg> orgList) {
    if (orgList == null || orgList.length == 0) {
      return Container();
    }

    List<Widget> list = List();

    renderUserOrgItem(UserOrg org) {
      return UserIconWidget(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        width: 30.0,
        height: 30.0,
        image: org.avatarUrl ?? TTIcons.DEFAULT_REMOTE_PIC,
        onPressed: () => NavigatorUtils.pushPersonDetailPage(context, org.login),
      );
    }

    int length = orgList.length > 3 ? 3 : orgList.length;

    list.add(Text(
      TTLocalizations.i18n(context).userOrgsTitle + ':',
      style: TTConstant.smallSubLightText,
    ));

    for (int i = 0; i < length; i++) {
      list.add(renderUserOrgItem(orgList[i]));
    }

    if (orgList.length > 3) {
      list.add(RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        onPressed: () {
          NavigatorUtils.pushCommonListPage(
            context,
            user.login + " " + TTLocalizations.i18n(context).userOrgsTitle,
            'org',
            'user_orgs',
            userName: user.login,
          );
        },
        child: Icon(
          Icons.more_horiz,
          color: TTColors.white,
          size: 18.0,
        ),
      ));
    }
    return Row(children: list);
  }

  _renderImage(BuildContext context) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
      onPressed: () {
        if (user.avatarUrl != null) {
          NavigatorUtils.pushPhotoViewPage(context, user.avatarUrl);
        }
      },
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: TTIcons.DEFAULT_USER_ICON,
          fit: BoxFit.fitWidth,
          image: user.avatarUrl ?? TTIcons.DEFAULT_REMOTE_PIC,
          width: 80.0,
          height: 80.0,
        ),
      ),
    );
  }

  _renderUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              user.login ?? '',
              style: TTConstant.largeTextWhiteBold,
            ),
            _renderNotifyIcon(context, notifyColor),
          ],
        ),
        Text(
          user.name ?? '',
          style: TTConstant.smallSubLightText,
        ),

        /// 用户组织
        TTIconText(
          user.company ?? TTLocalizations.i18n(context).nothingNow,
          TTIcons.USER_ITEM_COMPANY,
          TTConstant.smallSubLightText,
          TTColors.subLightTextColor,
          10.0,
          padding: 3.0,
        ),

        /// 用户位置
        TTIconText(
          user.location ?? TTLocalizations.i18n(context).nothingNow,
          TTIcons.USER_ITEM_LOCATION,
          TTConstant.smallSubLightText,
          TTColors.subLightTextColor,
          10.0,
          padding: 3.0,
        )
      ],
    );
  }

  _renderBlog(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        onPressed: () {
          if (user.blog != null) {
            CommonUtils.launchOutURL(user.blog, context);
          }
        },
        child: TTIconText(
          user.blog ?? TTLocalizations.i18n(context).nothingNow,
          TTIcons.USER_ITEM_LINK,
          (user.blog == null) ? TTConstant.smallSubLightText : TTConstant.smallActionLightText,
          TTColors.subLightTextColor,
          10.0,
          padding: 3.0,
          textWidth: MediaQuery.of(context).size.width - 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TTCardItem(
      color: themeColor,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderImage(context),
                Padding(padding: const EdgeInsets.all(10.0)),
                Expanded(
                  child: _renderUserInfo(context),
                ),
              ],
            ),
            _renderBlog(context),
            _renderUserOrgs(context, orgList),

            /// 用户描述
            Container(
              child: Text(
                user.bio ?? '',
                style: TTConstant.smallSubLightText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              alignment: Alignment.topLeft,
            ),

            /// 用户创建时长
            Container(
              child: Text(
                TTLocalizations.i18n(context).userCreateAt + CommonUtils.getDateStr(user.createdAt),
                style: TTConstant.smallSubLightText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              margin: const EdgeInsets.only(top: 6.0, bottom: 2.0),
              alignment: Alignment.topLeft,
            ),

            Padding(padding: const EdgeInsets.only(bottom: 5.0))
          ],
        ),
      ),
    );
  }
}

class UserHeaderBottom extends StatelessWidget {
  final User user;
  final String beStaredCount;
  final Radius radius;
  final List honorList;

  UserHeaderBottom(this.user, this.beStaredCount, this.radius, this.honorList);

  /// 绘制 底部item
  _renderBottomItem(String title, var value, onPressed) {
    String data = value == null ? '' : value.toString();
    TextStyle valueStyle =
        (value != null && value.toString().length > 6) ? TTConstant.minText : TTConstant.smallSubLightText;
    TextStyle titleStyle =
        (title != null && title.toString().length > 6) ? TTConstant.minText : TTConstant.smallSubLightText;

    return Expanded(
      child: Center(
        child: RawMaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.only(top: 5.0),
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: title, style: titleStyle),
                TextSpan(text: '\n', style: valueStyle),
                TextSpan(text: data, style: valueStyle)
              ],
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  _renderContainer() {
    return Container(
      width: 0.3,
      height: 40.0,
      alignment: Alignment.center,
      color: TTColors.subLightTextColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TTCardItem(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderBottomItem(
              TTLocalizations.of(context).currentLocalized.userTabRepos,
              user.publicRepos,
              () => NavigatorUtils.pushCommonListPage(
                context,
                user.login,
                'repository',
                'user_repos',
                userName: user.login,
              ),
            ),
            _renderContainer(),
            _renderBottomItem(
              TTLocalizations.i18n(context).userTabFans,
              user.followers,
              () => NavigatorUtils.pushCommonListPage(
                context,
                user.login,
                'user',
                'follower',
                userName: user.login,
              ),
            ),
            _renderContainer(),
            _renderBottomItem(
              TTLocalizations.i18n(context).userTabFocus,
              user.following,
              () => NavigatorUtils.pushCommonListPage(
                context,
                user.login,
                'user',
                'followed',
                userName: user.login,
              ),
            ),
            _renderContainer(),
            _renderBottomItem(
              TTLocalizations.i18n(context).userTabStar,
              user.starred,
              () => NavigatorUtils.pushCommonListPage(
                context,
                user.login,
                'repository',
                'user_star',
                userName: user.login,
              ),
            ),
            _renderContainer(),
            _renderBottomItem(
              TTLocalizations.i18n(context).userTabHonor,
              beStaredCount,
              () {
                if (honorList != null) {
                  NavigatorUtils.pushHonorListPage(context, honorList);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserHeaderChart extends StatelessWidget {
  final User user;

  UserHeaderChart(this.user);

  /// 绘制图表
  _renderChart(BuildContext context) {
    double height = 140.0;
    double width = 3 * MediaQuery.of(context).size.width / 2;
    if (user.login != null && user.type == 'Organization') {
      return Container();
    }
    return user.login != null
        ? Card(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            color: TTColors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: width,
                height: height,

                /// svg chart
                child: SvgPicture.network(
                  CommonUtils.getUserChartAddress(user.login),
                  width: width,
                  height: height - 10,
                  allowDrawingOutsideViewBox: true,
                  placeholderBuilder: (context) => Container(
                    width: width,
                    height: height,
                    child: Center(
                      child: SpinKitRipple(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: height,
            child: Center(
              child: SpinKitRipple(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(
              user.type == 'Organization'
                  ? TTLocalizations.i18n(context).userDynamicGroup
                  : TTLocalizations.i18n(context).userDynamicTitle,
              style: TTConstant.normalTextBold,
              overflow: TextOverflow.ellipsis,
            ),
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0),
            alignment: Alignment.topLeft,
          ),
          _renderChart(context)
        ],
      ),
    );
  }
}
