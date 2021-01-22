import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/issue_dao.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/net/interceptors/log_interceptor.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';

/// 错误页面
class ErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails details;

  ErrorPage(this.errorMessage, this.details);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  static List<Map<String, dynamic>> errorStacks = List<Map<String, dynamic>>();
  static List<String> errorNames = List<String>();

  final TextEditingController textEditingController = TextEditingController();

  addError(FlutterErrorDetails details) {
    try {
      var map = Map<String, dynamic>();
      map['error'] = details.toString();
      LogInterceptors.addLogic(errorNames, details.exception.runtimeType.toString());
      LogInterceptors.addLogic(errorStacks, map);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    return Container(
      color: TTColors.primaryValue,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            gradient: RadialGradient(
              tileMode: TileMode.mirror,
              radius: 0.1,
              colors: [
                Colors.white.withAlpha(10),
                TTColors.primaryValue.withAlpha(100),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(width / 2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(TTIcons.DEFAULT_USER_ICON),
                width: 90.0,
                height: 90.0,
              ),
              SizedBox(
                height: 11,
              ),
              Material(
                child: Text(
                  'Error Occur',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                color: TTColors.primaryValue,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: TTColors.white.withAlpha(100),
                    onPressed: () {
                      String content = widget.errorMessage;
                      textEditingController.text = content;
                      CommonUtils.showEditDialog(
                        context,
                        TTLocalizations.i18n(context).homeReply,
                        (title) {},
                        (res) => content = res,
                        () {
                          if (content == null || content.length == 0) {
                            return;
                          }
                          CommonUtils.showLoadingDialog(context);
                          IssueDao.createIssueDao(
                            'Germtao',
                            'flutter_github_app',
                            {"title": TTLocalizations.i18n(context).homeReply, "body": content},
                          ).then((result) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                        titleController: TextEditingController(),
                        valueController: textEditingController,
                        needTitle: false,
                      );
                    },
                    child: Text('Report'),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  FlatButton(
                    color: TTColors.white.withAlpha(100),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Back'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
