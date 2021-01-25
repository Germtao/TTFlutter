import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/repository.dart';
import 'package:flutter_github_app/model/repository_ql.dart';
import 'package:flutter_github_app/model/trending_repo.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_github_app/widget/icon/icon_user_widget.dart';
import 'package:flutter_github_app/widget/text/icon_text.dart';

/// 仓库 item
class ReposItem extends StatelessWidget {
  final ReposViewModel reposViewModel;

  final VoidCallback onPressed;

  ReposItem(
    this.reposViewModel, {
    this.onPressed,
  });

  /// 仓库 item 的底部状态，比如 star 数量等
  _renderBottomItem(
    BuildContext context,
    IconData iconData,
    String text, {
    int flex = 3,
  }) {
    return Expanded(
      flex: flex,
      child: Center(
        child: TTIconText(
          text,
          iconData,
          TTConstant.smallSubText,
          TTColors.subTextColor,
          15.0,
          padding: 5.0,
          textWidth:
              flex == 4 ? (MediaQuery.of(context).size.width - 100) / 3 : (MediaQuery.of(context).size.width - 100) / 5,
        ),
      ),
    );
  }

  /// 渲染 用户头像
  _renderUserAvatar(BuildContext context) {
    return UserIconWidget(
      padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 5.0),
      width: 40.0,
      height: 40.0,
      image: reposViewModel.ownerPic,
      onPressed: () {
        NavigatorUtils.pushPersonDetailPage(context, reposViewModel.ownerName);
      },
    );
  }

  /// 渲染仓库名和用户名
  _renderReposNameAndUserName() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reposViewModel.repositoryName ?? '',
            style: TTConstant.normalTextBold,
          ),
          TTIconText(
            reposViewModel.ownerName,
            TTIcons.REPOS_ITEM_USER,
            TTConstant.smallSubLightText,
            TTColors.subLightTextColor,
            10.0,
            padding: 3.0,
          )
        ],
      ),
    );
  }

  /// 渲染 仓库语言
  _renderReposLanguage() {
    return Text(
      reposViewModel.repositoryType,
      style: TTConstant.smallSubText,
    );
  }

  /// 渲染 仓库描述
  _renderReposDesc() {
    return Container(
      child: Text(
        reposViewModel.repositoryDes,
        style: TTConstant.smallSubText,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft,
    );
  }

  /// 渲染 仓库状态数值
  _renderReposStatus(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderBottomItem(
          context,
          TTIcons.REPOS_ITEM_STAR,
          reposViewModel.repositoryStar,
        ),
        SizedBox(
          width: 5,
        ),
        _renderBottomItem(
          context,
          TTIcons.REPOS_ITEM_FORK,
          reposViewModel.repositoryFork,
        ),
        SizedBox(
          width: 5,
        ),
        _renderBottomItem(
          context,
          TTIcons.REPOS_ITEM_ISSUE,
          reposViewModel.repositoryIssue,
          flex: 4,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TTCardItem(
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 10.0, bottom: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _renderUserAvatar(context),
                    _renderReposNameAndUserName(),
                    _renderReposLanguage(),
                  ],
                ),
                _renderReposDesc(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                _renderReposStatus(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReposViewModel {
  String ownerName;
  String ownerPic;
  String repositoryName;
  String repositoryStar;
  String repositoryFork;
  String repositoryIssue;
  String hideWatchIcon;
  String repositoryType = "";
  String repositoryDes;

  ReposViewModel();

  ReposViewModel.fromMap(Repository map) {
    ownerName = map.owner.login;
    ownerPic = map.owner.avatarUrl;
    repositoryName = map.name;
    repositoryStar = map.stargazersCount.toString();
    repositoryFork = map.forksCount.toString();
    repositoryIssue = map.openIssuesCount.toString();
    repositoryType = map.language ?? '---';
    repositoryDes = map.description ?? '---';
  }

  ReposViewModel.fromQL(RepositoryQL ql) {
    ownerName = ql.ownerName;
    ownerPic = ql.ownerAvatarUrl;
    repositoryName = ql.reposName;
    repositoryStar = ql.starCount.toString();
    repositoryFork = ql.forkCount.toString();
    repositoryIssue = ql.issuesOpen.toString();
    repositoryType = ql.language ?? '---';
    repositoryDes = CommonUtils.removeTextTag(ql.shortDescriptionHTML) ?? '---';
  }

  ReposViewModel.fromTrendMap(TrendingRepo map) {
    ownerName = map.name;
    ownerPic = map.contributorsUrl.length > 0 ? map.contributors[0] : '';
    repositoryName = map.reposName;
    repositoryStar = map.starCount.toString();
    repositoryFork = map.forkCount.toString();
    repositoryIssue = map.meta;
    repositoryType = map.language;
    repositoryDes = CommonUtils.removeTextTag(map.description);
  }
}
