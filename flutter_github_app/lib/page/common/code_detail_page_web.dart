import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/html_utils.dart';
import 'package:flutter_github_app/widget/tab_bar/title_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 文件代码详情 web 页面
class CodeDetailPageWeb extends StatefulWidget {
  final String userName;

  final String reposName;

  final String path;

  final String data;

  final String title;

  final String branch;

  final String htmlUrl;

  CodeDetailPageWeb({
    this.title,
    this.userName,
    this.reposName,
    this.path,
    this.data,
    this.branch,
    this.htmlUrl,
  });

  @override
  _CodeDetailPageWebState createState() => _CodeDetailPageWebState();
}

class _CodeDetailPageWebState extends State<CodeDetailPageWeb> {
  bool isLand = false;

  Future<String> _getData() async {
    if (widget.data != null) {
      return widget.data;
    }

    var res = await ReposDao.getRepositoryFileDirsDao(
      widget.userName,
      widget.reposName,
      path: widget.path,
      branch: widget.branch,
      text: true,
      isHtml: true,
    );
    if (res != null && res.result) {
      String data2 = HtmlUtils.resolveHtmlFile(res, 'java');
      String url = Uri.dataFromString(
        data2,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString();
      return url;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleBar(widget.title),
      ),
      body: FutureBuilder<String>(
        initialData: widget.data,
        future: _getData(),
        builder: (context, result) {
          if (result.data == null || result.data.isEmpty) {
            return Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitDoubleBounce(
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(width: 10.0),
                    Container(
                      child: Text(
                        TTLocalizations.i18n(context).loadingText,
                        style: TTConstant.middleText,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return WebView(
            initialUrl: result.data,
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isLand ? Icons.screen_lock_landscape : Icons.screen_lock_portrait,
        ),
        onPressed: () {
          setState(() {
            if (isLand) {
              isLand = false;
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            } else {
              isLand = true;
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
              ]);
            }
          });
        },
      ),
    );
  }
}
