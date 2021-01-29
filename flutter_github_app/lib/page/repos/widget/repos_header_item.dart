import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/repository_ql.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_github_app/widget/text/icon_text.dart';

/// 仓库详情头部控件
class ReposHeaderItem extends StatefulWidget {
  final ReposHeaderViewModel reposHeaderViewModel;

  final ValueChanged<Size> layoutListener;

  ReposHeaderItem(this.reposHeaderViewModel, {this.layoutListener});

  @override
  _ReposHeaderItemState createState() => _ReposHeaderItemState();
}

class _ReposHeaderItemState extends State<ReposHeaderItem> {
  final GlobalKey layoutKey = GlobalKey();
  final GlobalKey layoutTopicContainerKey = GlobalKey();
  final GlobalKey layoutLastTopicKey = GlobalKey();

  double widgetHeight = 0.0;

  /// 绘制 顶部信息
  _renderTopNameInfo() {
    return Row(
      children: [
        /// 用户名
        RawMaterialButton(
          constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          padding: const EdgeInsets.all(0.0),
          onPressed: () => NavigatorUtils.pushPersonDetailPage(context, widget.reposHeaderViewModel.ownerName),
          child: Text(
            widget.reposHeaderViewModel.ownerName,
            style: TTConstant.normalTextActionWhiteBold.copyWith(shadows: [
              BoxShadow(color: Colors.black, offset: Offset(0.5, 0.5)),
            ]),
          ),
        ),
        Text(
          ' / ',
          style: TTConstant.normalTextActionWhiteBold.copyWith(shadows: [
            BoxShadow(color: Colors.black, offset: Offset(0.5, 0.5)),
          ]),
        ),

        /// 仓库名
        Expanded(
          child: Text(
            widget.reposHeaderViewModel.repositoryName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TTConstant.normalTextActionWhiteBold.copyWith(shadows: [
              BoxShadow(color: Colors.black, offset: Offset(0.5, 0.5)),
            ]),
          ),
        )
      ],
    );
  }

  /// 绘制 次要信息
  _renderSubInfo() {
    return Row(
      children: [
        /// 仓库语言
        Text(
          widget.reposHeaderViewModel.repositoryType ?? '--',
          style: TTConstant.smallSubLightText.copyWith(shadows: [
            BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
          ]),
        ),
        Container(width: 5.3, height: 1.0),

        /// 仓库大小
        Text(
          widget.reposHeaderViewModel.repositorySize ?? '--',
          style: TTConstant.smallSubLightText.copyWith(shadows: [
            BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
          ]),
        ),
        Container(width: 5.3, height: 1.0),

        /// 仓库协议
        Expanded(
          child: Text(
            widget.reposHeaderViewModel.license ?? '--',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TTConstant.smallSubLightText.copyWith(shadows: [
              BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
            ]),
          ),
        )
      ],
    );
  }

  /// 绘制 仓库描述
  _renderDesc() {
    return Container(
      child: Text(
        CommonUtils.removeTextTag(widget.reposHeaderViewModel.repositoryDes) ?? '---',
        style: TTConstant.smallSubLightText.copyWith(shadows: [
          BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
        ]),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      margin: const EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft,
    );
  }

  /// 绘制 仓库右下角的信息
  _renderStatus() {
    return Container(
      margin: const EdgeInsets.only(top: 6.0, right: 5.0, bottom: 2.0),
      alignment: Alignment.topRight,
      child: RawMaterialButton(
        onPressed: () {
          if (widget.reposHeaderViewModel.repositoryIsFork) {
            NavigatorUtils.pushReposDetailPage(
              context,
              widget.reposHeaderViewModel.repositoryParentUser,
              widget.reposHeaderViewModel.repositoryName,
            );
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: Text(
          _getInfoText(context),
          style: _getInfoTextStyle(),
        ),
      ),
    );
  }

  /// 绘制 仓库状态底部信息 item
  _renderBottomItem(IconData iconData, String text, onPressed) {
    return Expanded(
      child: Center(
        child: RawMaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          child: TTIconText(
            text,
            iconData,
            TTConstant.smallSubLightText.copyWith(shadows: [
              BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
            ]),
            TTColors.subLightTextColor,
            15.0,
            padding: 3.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  _renderBottomMargin() {
    return Container(
      width: 0.3,
      height: 25.0,
      decoration: BoxDecoration(
        color: TTColors.subLightTextColor,
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
        ],
      ),
    );
  }

  /// 绘制 仓库状态底部信息
  _renderBottomInfo() {
    return Padding(
      padding: const EdgeInsets.all(0.0),

      /// 创建数值状态
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// star 状态
          _renderBottomItem(
            TTIcons.REPOS_ITEM_STAR,
            widget.reposHeaderViewModel.repositoryStar,
            () {
              NavigatorUtils.pushCommonListPage(
                context,
                widget.reposHeaderViewModel.repositoryName,
                'user',
                'repo_star',
                userName: widget.reposHeaderViewModel.ownerName,
                reposName: widget.reposHeaderViewModel.repositoryName,
              );
            },
          ),

          _renderBottomMargin(),

          /// fork 状态
          _renderBottomItem(
            TTIcons.REPOS_ITEM_FORK,
            widget.reposHeaderViewModel.repositoryFork,
            () {
              NavigatorUtils.pushCommonListPage(
                context,
                widget.reposHeaderViewModel.repositoryName,
                'repository',
                'repo_fork',
                userName: widget.reposHeaderViewModel.ownerName,
                reposName: widget.reposHeaderViewModel.repositoryName,
              );
            },
          ),

          _renderBottomMargin(),

          /// 订阅状态
          _renderBottomItem(
            TTIcons.REPOS_ITEM_WATCH,
            widget.reposHeaderViewModel.repositoryWatch,
            () {
              NavigatorUtils.pushCommonListPage(
                context,
                widget.reposHeaderViewModel.repositoryName,
                'user',
                'repo_watcher',
                userName: widget.reposHeaderViewModel.ownerName,
                reposName: widget.reposHeaderViewModel.repositoryName,
              );
            },
          ),

          _renderBottomMargin(),

          /// issue状态
          _renderBottomItem(
            TTIcons.REPOS_ITEM_ISSUE,
            widget.reposHeaderViewModel.repositoryIssue,
            () {
              if (widget.reposHeaderViewModel.allIssueCount == null || widget.reposHeaderViewModel.allIssueCount <= 0) {
                return;
              }
              List<String> list = [
                TTLocalizations.i18n(context).reposAllIssueCount + widget.reposHeaderViewModel.allIssueCount.toString(),
                TTLocalizations.i18n(context).reposOpenIssueCount +
                    widget.reposHeaderViewModel.openIssuesCount.toString(),
                TTLocalizations.i18n(context).reposCloseIssueCount +
                    (widget.reposHeaderViewModel.allIssueCount - widget.reposHeaderViewModel.openIssuesCount)
                        .toString(),
              ];
              CommonUtils.showCommitOptionDialog(context, list, (index) {}, height: 150.0);
            },
          )
        ],
      ),
    );
  }

  /// 话题控件
  _renderTopicItem(BuildContext context, String item, index) {
    return RawMaterialButton(
      key: index == widget.reposHeaderViewModel.topics.length - 1 ? layoutLastTopicKey : null,
      onPressed: () {
        NavigatorUtils.pushCommonListPage(
          context,
          item,
          'repository',
          'topics',
          userName: item,
          reposName: '',
        );
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(0.0),
      constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: Colors.white30,
          border: Border.all(color: Colors.white30, width: 0.0),
        ),
        child: Text(
          item,
          style: TTConstant.smallSubLightText.copyWith(shadows: [
            BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
          ]),
        ),
      ),
    );
  }

  /// 绘制 话题组控件
  _renderTopicGroup(BuildContext context) {
    if (widget.reposHeaderViewModel.topics == null || widget.reposHeaderViewModel.topics.length == 0) {
      return Container(key: layoutTopicContainerKey);
    }
    List<Widget> list = List();
    for (var i = 0; i < widget.reposHeaderViewModel.topics.length; i++) {
      var item = widget.reposHeaderViewModel.topics[i];
      list.add(_renderTopicItem(context, item, i));
    }
    return Container(
      key: layoutTopicContainerKey,
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 5.0,
        children: list,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ReposHeaderItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 如果存在 tag，根据 tag 去判断，修复溢出
    Future.delayed(const Duration(seconds: 0), () {
      /// tag 所在的 container
      RenderBox renderBox = layoutTopicContainerKey.currentContext?.findRenderObject();

      var dy = renderBox?.localToGlobal(Offset.zero, ancestor: layoutKey?.currentContext?.findRenderObject())?.dy;
      var sizeTagContainer = layoutTopicContainerKey?.currentContext?.size ?? null;
      var headerSize = layoutKey?.currentContext?.size;

      if (dy > 0 && headerSize != null && sizeTagContainer != null) {
        /// 20 是 card 的上下 padding
        var newSize = dy + sizeTagContainer.height + 20;
        if (widgetHeight != newSize && newSize > 0) {
          print('widget?.layoutListener?.call');
          widgetHeight = newSize;
          widget?.layoutListener?.call(Size(layoutKey.currentContext.size.width, widgetHeight));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: layoutKey,
      child: TTCardItem(
        color: Theme.of(context).primaryColor,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.reposHeaderViewModel.ownerPic ?? TTIcons.DEFAULT_REMOTE_PIC),
              ),
            ),
            child: BackdropFilter(
              /// 高斯模糊
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _renderTopNameInfo(),
                    _renderSubInfo(),
                    _renderDesc(),
                    _renderStatus(),
                    Divider(color: TTColors.subTextColor),
                    _renderBottomInfo(),
                    _renderTopicGroup(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 获取 仓库创建和提交状态信息
  _getInfoText(BuildContext context) {
    String createStr = widget.reposHeaderViewModel.repositoryIsFork
        ? TTLocalizations.i18n(context).reposForkAt + widget.reposHeaderViewModel.repositoryParentName + '\n'
        : TTLocalizations.i18n(context).reposCreateAt + widget.reposHeaderViewModel.createdAt + '\n';

    String updateStr = TTLocalizations.i18n(context).reposLastCommit + widget.reposHeaderViewModel.pushAt;

    return createStr + (widget.reposHeaderViewModel.pushAt != null ? updateStr : '');
  }

  /// 获取 仓库创建和提交状态信息 style
  _getInfoTextStyle() {
    TextStyle style = widget.reposHeaderViewModel.repositoryIsFork
        ? TTConstant.smallActionLightText.copyWith(shadows: [
            BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
          ])
        : TTConstant.smallSubLightText.copyWith(shadows: [
            BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5)),
          ]);
  }
}

class ReposHeaderViewModel {
  String ownerName = '---';
  String ownerPic;
  String repositoryName = "---";
  String repositorySize = "---";
  String repositoryStar = "---";
  String repositoryFork = "---";
  String repositoryWatch = "---";
  String repositoryIssue = "---";
  String repositoryIssueClose = "";
  String repositoryIssueAll = "";
  String repositoryType = "---";
  String repositoryDes = "---";
  String repositoryLastActivity = "";
  String repositoryParentName = "";
  String repositoryParentUser = "";
  String createdAt = "";
  String pushAt = "";
  String license = "";
  List<String> topics;
  int allIssueCount = 0;
  int openIssuesCount = 0;
  bool repositoryStared = false;
  bool repositoryForked = false;
  bool repositoryWatched = false;
  bool repositoryIsFork = false;

  ReposHeaderViewModel();

  ReposHeaderViewModel.fromHttpMap(ownerName, reposName, RepositoryQL repositoryQL) {
    this.ownerName = ownerName;
    if (repositoryQL == null || repositoryQL.ownerName == null) {
      return;
    }

    this.ownerPic = repositoryQL.ownerAvatarUrl;
    this.repositoryName = reposName;
    this.allIssueCount = repositoryQL.issuesTotal;
    this.topics = repositoryQL.topics;
    this.openIssuesCount = repositoryQL.issuesOpen;
    this.repositoryStar = repositoryQL.starCount != null ? repositoryQL.starCount.toString() : '';
    this.repositoryFork = repositoryQL.forkCount != null ? repositoryQL.forkCount.toString() : '';
    this.repositoryWatch = repositoryQL.watcherCount != null ? repositoryQL.watcherCount.toString() : '';
    this.repositoryIssue = repositoryQL.issuesOpen != null ? repositoryQL.issuesOpen.toString() : '';

    this.repositorySize = (repositoryQL.size / 1024.0).toString().substring(0, 3) + 'M';
    this.repositoryType = repositoryQL.language;
    this.repositoryDes = repositoryQL.shortDescriptionHTML;
    this.repositoryIsFork = repositoryQL.isFork;
    this.license = repositoryQL.license ?? '';
    this.repositoryParentName = repositoryQL.parent != null ? repositoryQL.parent.reposName : '';
    this.repositoryParentUser = repositoryQL.parent != null ? repositoryQL.parent.ownerName : '';
    this.createdAt = CommonUtils.getNewsTimeStr(DateTime.parse(repositoryQL.createdAt));
    this.pushAt = CommonUtils.getNewsTimeStr(DateTime.parse(repositoryQL.pushAt));
  }
}
