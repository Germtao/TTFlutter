import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/model/file_model.dart';
import 'package:flutter_github_app/page/repos/scope/repos_detail_model.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';
import 'package:flutter_github_app/widget/pull/pull_load_old_widget.dart';
import 'package:flutter_github_app/widget/pull/state/common_list_state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';

/// 仓库文件列表页面
class RepositoryFileListPage extends StatefulWidget {
  final String userName;

  final String reposName;

  RepositoryFileListPage(
    this.userName,
    this.reposName, {
    Key key,
  }) : super(key: key);

  @override
  RepositoryFileListPageState createState() => RepositoryFileListPageState();
}

class RepositoryFileListPageState extends State<RepositoryFileListPage>
    with AutomaticKeepAliveClientMixin<RepositoryFileListPage>, CommonListState<RepositoryFileListPage> {
  String path = '';

  String searchText;

  String issueState;

  List<String> headerList = ['.'];

  /// 绘制 头部列表
  _renderHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            padding: const EdgeInsets.all(4.0),
            onPressed: () => _resolveHeaderClick(index),
            child: Text(
              headerList[index] + ' > ',
              style: TTConstant.smallText,
            ),
          );
        },
      ),
    );
  }

  /// 头部列表点击
  _resolveHeaderClick(index) {
    if (isLoading) {
      Fluttertoast.showToast(msg: TTLocalizations.i18n(context).loadingText);
      return;
    }

    if (headerList[index] != '.') {
      List<String> newHeaderList = headerList.sublist(0, index + 1);
      String path = newHeaderList.sublist(1, newHeaderList.length).join('/');
      setState(() {
        this.path = path;
        headerList = newHeaderList;
      });
      showRefreshLoading();
    } else {
      setState(() {
        path = '';
        headerList = ['.'];
      });
      showRefreshLoading();
    }
  }

  /// 返回按键逻辑
  Future<bool> _dialogExitApp(BuildContext context) {
    if (ReposDetailModel.of(context).currentIndex != 3) {
      return Future.value(true);
    }
    if (headerList.length == 1) {
      return Future.value(true);
    } else {
      _resolveHeaderClick(headerList.length - 2);
      return Future.value(false);
    }
  }

  _resolveItemClick(FileItemViewModel fileItemViewModel) {
    if (fileItemViewModel.type == 'dir') {
      if (isLoading) {
        Fluttertoast.showToast(msg: TTLocalizations.i18n(context).loadingText);
        return;
      }
      setState(() {
        headerList.add(fileItemViewModel.name);
      });
      String path = headerList.sublist(1, headerList.length).join('/');
      setState(() {
        this.path = path;
      });
      showRefreshLoading();
    } else {
      String path = headerList.sublist(1, headerList.length).join('/') + '/' + fileItemViewModel.name;
      if (CommonUtils.isImageEnd(fileItemViewModel.name)) {
        NavigatorUtils.pushPhotoViewPage(context, fileItemViewModel.htmlUrl + '?raw=true');
      } else {
        NavigatorUtils.pushCodeDetailWebForPlatform(
          context,
          title: fileItemViewModel.name,
          reposName: widget.reposName,
          userName: widget.userName,
          path: path,
          branch: ReposDetailModel.of(context).currentBranch,
        );
      }
    }
  }

  /// 绘制 文件item
  _renderFileItem(index) {
    FileItemViewModel fileItemViewModel = FileItemViewModel.fromMap(pullLoadOldWidgetControl.dataList[index]);
    IconData iconData = fileItemViewModel.type == 'file' ? TTIcons.REPOS_ITEM_FILE : TTIcons.REPOS_ITEM_DIR;
    Widget trailing = fileItemViewModel.type == 'file' ? null : Icon(TTIcons.REPOS_ITEM_NEXT, size: 12.0);

    return TTCardItem(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: ListTile(
        title: Text(
          fileItemViewModel.name,
          style: TTConstant.smallSubText,
        ),
        leading: Icon(
          iconData,
          size: 16.0,
        ),
        onTap: () => _resolveItemClick(fileItemViewModel),
        trailing: trailing,
      ),
    );
  }

  _getDataLogic(String searchText) async {
    return await ReposDao.getRepositoryFileDirsDao(
      widget.userName,
      widget.reposName,
      path: path,
      branch: ReposDetailModel.of(context).currentBranch,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: TTColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: TTColors.mainBackgroundColor,
        leading: Container(),
        elevation: 0.0,
        flexibleSpace: _renderHeader(),
      ),
      body: WillPopScope(
        onWillPop: () {
          return _dialogExitApp(context);
        },
        child: ScopedModelDescendant<ReposDetailModel>(
          builder: (context, child, model) {
            return PullLoadOldWidget(
              pullLoadOldWidgetControl,
              (context, index) => _renderFileItem(index),
              handleRefresh,
              onLoadMore,
              refreshKey: refreshIndicatorKey,
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => true;

  @override
  bool get isRefreshFirst => true;

  @override
  requestRefresh() async {
    return await _getDataLogic(searchText);
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic(searchText);
  }
}

class FileItemViewModel {
  String type;
  String name;
  String htmlUrl;

  FileItemViewModel();

  FileItemViewModel.fromMap(FileModel map) {
    name = map.name;
    type = map.type;
    htmlUrl = map.htmlUrl;
  }
}
