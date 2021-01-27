import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/model/repository_ql.dart';
import 'package:flutter_github_app/page/repos/repos_detail_page.dart';
import 'package:scoped_model/scoped_model.dart';

/// 仓库详情数据实体，包含有当前 index，仓库数据、分支等
class ReposDetailModel extends Model {
  static ReposDetailModel of(BuildContext context) => ScopedModel.of<ReposDetailModel>(context);

  final String userName;

  final String reposName;

  ReposDetailModel({this.userName, this.reposName});

  int _currentIndex = 0;

  String _currentBranch = 'master';

  RepositoryQL _repositoryQL;

  BottomStatusModel _bottomStatusModel;

  List<Widget> _footerButtons;

  List<String> _branches;

  /// ########## set、get ########## ///

  RepositoryQL get repositoryQL => _repositoryQL;

  set repositoryQL(RepositoryQL data) {
    _repositoryQL = data;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String get currentBranch => _currentBranch;

  set currentBranch(String branch) {
    _currentBranch = branch;
    notifyListeners();
  }

  BottomStatusModel get bottomStatusModel => _bottomStatusModel;

  set bottomStatusModel(BottomStatusModel statusModel) {
    _bottomStatusModel = statusModel;
    notifyListeners();
  }

  List<Widget> get footerButtons => _footerButtons;

  set footerButtons(List<Widget> buttons) {
    _footerButtons = buttons;
    notifyListeners();
  }

  List<String> get branches => _branches;

  set branches(List<String> data) {
    _branches = data;
    notifyListeners();
  }

  /// ############################# ///

  /// 获取网络端仓库 star 等状态
  getRepositoryStatus(List<Widget> getBottomWidgets()) async {
    String watchText = repositoryQL.isSubscription == 'SUBSCRIBED' ? 'UnWatch' : 'Watch';

    String starText = repositoryQL.isStared ? 'UnStar' : 'Star';

    IconData watchIcon =
        repositoryQL.isSubscription == 'SUBSCRIBED' ? TTIcons.REPOS_ITEM_WATCHED : TTIcons.REPOS_ITEM_WATCH;

    IconData starIcon = repositoryQL.isStared ? TTIcons.REPOS_ITEM_STARED : TTIcons.REPOS_ITEM_STAR;

    BottomStatusModel statusModel = BottomStatusModel(watchText, starText, watchIcon, starIcon);

    bottomStatusModel = statusModel;

    footerButtons = getBottomWidgets();
  }

  /// 获取分支列表数据
  getBranchList() async {
    var result = await ReposDao.getBranchesDao(userName, reposName);
    if (result != null && result.result) {
      branches = result.data;
    }
  }
}
