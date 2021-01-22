import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/style/style.dart';

import 'package:flutter_github_app/model/search_user_ql.dart';
import 'package:flutter_github_app/model/user.dart';
import 'package:flutter_github_app/model/user_org.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// 用户 item
class UserItem extends StatelessWidget {
  final UserItemViewModel userItemViewModel;

  final VoidCallback onPressed;

  final needImage;

  UserItem(
    this.userItemViewModel, {
    this.onPressed,
    this.needImage = true,
  });

  @override
  Widget build(BuildContext context) {
    var userInfo = StoreProvider.of<TTState>(context).state.userInfo;
    Widget userImage = IconButton(
      padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 10.0, bottom: 0.0),
      icon: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: TTIcons.DEFAULT_USER_ICON,
          fit: BoxFit.fitWidth,
          image: userItemViewModel.userPic,
          width: 40.0,
          height: 40.0,
        ),
      ),
      onPressed: null,
    );
    return Container(
      child: TTCardItem(
        color: userInfo.login == userItemViewModel.login
            ? Colors.amber
            : (userItemViewModel.login == 'Germtao')
                ? Colors.pink
                : Colors.white,
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 10.0),
            child: Row(
              children: [
                if (userItemViewModel.index != null)
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      userItemViewModel.index,
                      style: TTConstant.middleSubTextBold,
                    ),
                  ),
                userImage,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userItemViewModel.userName ?? 'null',
                            style: TTConstant.smallTextBold,
                          ),
                          if (userItemViewModel.followers != null)
                            Expanded(
                              child: Align(
                                child: Text(
                                  'followers: ${userItemViewModel.followers}',
                                  style: TTConstant.smallSubText,
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                        ],
                      ),
                      if (userItemViewModel.bio != null && userItemViewModel.bio.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            userItemViewModel.bio,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TTConstant.smallText,
                          ),
                        ),
                      if (userItemViewModel.lang != null)
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, right: 10.0),
                          child: Text(
                            userItemViewModel.lang,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TTConstant.smallSubText,
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserItemViewModel {
  String userPic;
  String userName;
  String bio;
  int followers;
  String login;
  String lang;
  String index;

  UserItemViewModel.fromMap(User user) {
    userName = user.login;
    userPic = user.avatarUrl;
    followers = user.followers;
  }

  UserItemViewModel.fromQL(SearchUserQL user, int index) {
    userName = user.name;
    userPic = user.avatarUrl;
    followers = user.followers;
    bio = user.bio;
    login = user.login;
    lang = user.lang;
    this.index = index.toString();
  }

  UserItemViewModel.fromOrgMap(UserOrg org) {
    userName = org.login;
    userPic = org.avatarUrl;
  }
}
