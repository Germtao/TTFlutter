import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginWebView extends StatefulWidget {
  final String urlStr;
  final String title;

  LoginWebView(this.urlStr, this.title);

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final FlutterWebviewPlugin webviewPlugin = FlutterWebviewPlugin();

  _renderTitle() {
    if (widget.urlStr == null || widget.urlStr.length == 0) {
      return Text(widget.title);
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  _renderLoading() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
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

  @override
  void initState() {
    super.initState();
    webviewPlugin.onStateChanged.listen((state) {
      if (mounted) {
        if (state.type == WebViewState.shouldStart) {
          print('webview should start: ${state.url}');
          if (state.url != null && state.url.startsWith('ttfluttergithubapp://authed')) {
            var code = Uri.parse(state.url).queryParameters['code'];
            print('webview should start code: $code');
            webviewPlugin.reloadUrl('about:blank');
            Navigator.of(context).pop(code);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    webviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebviewScaffold(
            appBar: AppBar(
              title: _renderTitle(),
            ),
            initialChild: _renderLoading(),
            url: widget.urlStr,
          )
        ],
      ),
    );
  }
}
