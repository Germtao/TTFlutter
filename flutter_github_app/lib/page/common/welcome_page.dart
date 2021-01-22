import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_github_app/widget/common/mole_widget.dart';
import 'package:flutter_github_app/widget/text/diff_scale_text.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

/// 欢迎页
class WelcomePage extends StatefulWidget {
  static final String className = '/';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  String text = '';
  double fontSize = 76;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (hadInit) return;

    hadInit = true;

    // 防止多次进入
    Store<TTState> store = StoreProvider.of(context);
    new Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        text = 'Welcome';
        fontSize = 60;
      });
    });
    Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        text = 'FlutterGithubApp';
        fontSize = 60;
      });
    });
    Future.delayed(Duration(seconds: 2, milliseconds: 500), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.pushHomePage(context);
        } else {
          NavigatorUtils.pushLoginPage(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<TTState>(
      builder: (context, store) {
        double size = 200;
        return Material(
          child: Container(
            color: TTColors.white,
            child: Stack(
              children: [
                Center(
                  child: Image(
                    image: AssetImage('static/images/welcome.png'),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.3),
                  child: DiffScaleText(
                    text: text,
                    textStyle: GoogleFonts.akronim().copyWith(
                      color: TTColors.primaryDarkValue,
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.8),
                  child: MoleWidget(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: size,
                    height: size,
                    child: FlareActor(
                      'static/files/flare_flutter_logo_.flr',
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                      animation: 'Placeholder',
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
