import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/model/file_model.dart';
import 'package:flutter_github_app/page/repos/scope/repos_detail_model.dart';
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
  _RepositoryFileListPageState createState() => _RepositoryFileListPageState();
}

class _RepositoryFileListPageState extends State<RepositoryFileListPage>
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

  /// 绘制 文件item
  _renderFileItem(index) {
    FileItemViewModel fileItemViewModel = FileItemViewModel.fromMap(pullLoadOldWidgetControl.dataList[index]);
    IconData iconData = fileItemViewModel.type == 'file' ? TTIcons.REPOS_ITEM_FILE : TTIcons.REPOS_ITEM_DIR;
    Widget trailing = fileItemViewModel.type == 'file' ? null : Icon(TTIcons.REPOS_ITEM_NEXT, size: 12.0);
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
              // (context, index) => ,
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
