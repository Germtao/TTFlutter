import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/page/repos/scope/repos_detail_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// readme
class ReposDetailReadmePage extends StatefulWidget {
  final String userName;

  final String reposName;

  ReposDetailReadmePage(this.userName, this.reposName, {Key key}) : super(key: key);

  @override
  ReposDetailReadmePageState createState() => ReposDetailReadmePageState();
}

class ReposDetailReadmePageState extends State<ReposDetailReadmePage> with AutomaticKeepAliveClientMixin {
  bool isShow = false;

  String markdownData;

  ReposDetailReadmePageState();

  refreshReadme() {
    ReposDao.getRepositoryDetailReadmeDao(
      widget.userName,
      widget.reposName,
      ReposDetailModel.of(context).currentBranch,
    ).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
          return res.next?.call();
        }
      }
      return Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
        }
      }
    });
  }

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var widget = markdownData == null
    ? Center(
      child: Container(width: 200.0, height: 200.0, padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDoubleBounce(color: Theme.of(context).primaryColor,),
          Container(width: 10.0),
          Container(child: Text(TTLocalizations.i18n(context).loadingText, style: TTConstant.middleText,),)
        ],
      ),),
    )
    : 
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
