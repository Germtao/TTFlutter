import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:package_info/package_info.dart';

import '../../common/config/config.dart';
import '../../common/dao/issue_dao.dart';
import '../../common/dao/repos_dao.dart';
import '../../common/local/local_storage.dart';
import '../../common/localization/default_localizations.dart';
import '../../common/style/style.dart';
import '../../common/utils/common_utils.dart';
import '../../common/utils/navigator_utils.dart';

import '../../widget/button/tt_flex_button.dart';

import '../../redux/state.dart';
import '../../redux/login_redux.dart';

import '../../model/user.dart';

/// 主页 drawer
class HomeDrawer extends StatelessWidget {
  showAboutDialog(BuildContext context, String versionName) {
    versionName ??= 'null';
    NavigatorUtils.showTTDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: TTLocalizations.i18n(context).appName,
        applicationVersion: TTLocalizations.i18n(context).appVersion + ': ' + versionName,
        applicationIcon: Image(
          image: AssetImage(TTIcons.DEFAULT_USER_ICON),
          width: 50.0,
          height: 50.0,
        ),
        applicationLegalese: 'http://github.com/Germtao',
      ),
    );
  }

  showThemeDialog(BuildContext context, Store store) {
    List<String> list = [
      TTLocalizations.i18n(context).homeThemeDefault,
      TTLocalizations.i18n(context).homeTheme_1,
      TTLocalizations.i18n(context).homeTheme_2,
      TTLocalizations.i18n(context).homeTheme_3,
      TTLocalizations.i18n(context).homeTheme_4,
      TTLocalizations.i18n(context).homeTheme_5,
      TTLocalizations.i18n(context).homeTheme_6,
    ];
    CommonUtils.showCommitOptionDialog(
      context,
      list,
      (index) {
        CommonUtils.pushTheme(store, index);
        LocalStorage.save(Config.THEME_COLOR, index.toString());
      },
      colorList: CommonUtils.getThemeListColor(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StoreBuilder<TTState>(
        builder: (context, store) {
          User user = store.state.userInfo;
          return Drawer(
            // 侧边栏按钮 drawer
            child: Container(
              // 默认背景色
              color: store.state.themeData.primaryColor,
              child: SingleChildScrollView(
                // item 背景
                child: Container(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  child: Material(
                    color: TTColors.white,
                    child: Column(
                      children: [
                        UserAccountsDrawerHeader(
                          accountName: Text(
                            user.login ?? '---',
                            style: TTConstant.largeTextWhite,
                          ),
                          accountEmail: Text(
                            user.email ?? user.name ?? '---',
                            style: TTConstant.normalTextLight,
                          ),
                          currentAccountPicture: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.avatarUrl ?? TTIcons.DEFAULT_REMOTE_PIC),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: store.state.themeData.primaryColor,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            TTLocalizations.i18n(context).homeReply,
                            style: TTConstant.normalText,
                          ),
                          onTap: () {
                            String _content = '';
                            CommonUtils.showEditDialog(
                              context,
                              TTLocalizations.i18n(context).homeReply,
                              (title) {},
                              (content) => _content = content,
                              () {
                                if (_content == null || _content.length == 0) {
                                  return;
                                }
                                CommonUtils.showLoadingDialog(context);
                                IssueDao.createIssueDao(
                                  'Germtao',
                                  'flutter_github_app',
                                  {
                                    'title': TTLocalizations.i18n(context).homeReply,
                                    'body': _content,
                                  },
                                ).then((result) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              },
                              titleController: TextEditingController(),
                              valueController: TextEditingController(),
                              needTitle: false,
                            );
                          },
                        ),
                        ListTile(
                          title: Text(
                            TTLocalizations.i18n(context).homeHistory,
                            style: TTConstant.normalText,
                          ),
                          onTap: () {
                            NavigatorUtils.pushCommonListPage(
                              context,
                              TTLocalizations.i18n(context).homeHistory,
                              'repositoryql',
                              'history',
                              userName: '',
                              reposName: '',
                            );
                          },
                        ),
                        ListTile(
                          title: Hero(
                            tag: 'home_user_info',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                TTLocalizations.i18n(context).homeUserInfo,
                                style: TTConstant.normalTextBold,
                              ),
                            ),
                          ),
                          onTap: () => NavigatorUtils.pushUserProfileInfoPage(context),
                        ),
                        ListTile(
                          title: Text(
                            TTLocalizations.i18n(context).homeChangeTheme,
                            style: TTConstant.normalText,
                          ),
                          onTap: () => showThemeDialog(context, store),
                        ),
                        ListTile(
                          title: Text(
                            TTLocalizations.i18n(context).homeChangeLanguage,
                            style: TTConstant.normalText,
                          ),
                          onTap: () => CommonUtils.showLanguageDialog(context),
                        ),
                        ListTile(
                          title: Text(
                            TTLocalizations.i18n(context).homeCheckUpdate,
                            style: TTConstant.normalText,
                          ),
                          onTap: () => ReposDao.getNewsVersion(context, true),
                        ),
                        ListTile(
                          title: Text(
                            TTLocalizations.of(context).currentLocalized.homeAbout,
                            style: TTConstant.normalText,
                          ),
                          onLongPress: () => NavigatorUtils.pushDebugDataPage(context),
                          onTap: () {
                            PackageInfo.fromPlatform().then((value) {
                              print('about: $value');
                              showAboutDialog(context, value.version);
                            });
                          },
                        ),
                        ListTile(
                          title: TTFlexButton(
                            text: TTLocalizations.i18n(context).loginOut,
                            color: Colors.redAccent,
                            textColor: TTColors.textWhite,
                            onPress: () => store.dispatch(LogoutAction(context)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
