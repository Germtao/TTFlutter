import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/common/utils/common_utils.dart';
import 'package:flutter_github_app/widget/button/tt_flex_button.dart';
import 'package:flutter_github_app/widget/common/animated_background.dart';
import 'package:flutter_github_app/widget/input/tt_input_widget.dart';
import 'package:flutter_github_app/widget/particle/particle_widget.dart';
import 'package:flutter_github_app/common/config/config.dart';
import 'package:flutter_github_app/common/local/local_storage.dart';
import 'package:flutter_github_app/common/net/address.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';
import 'package:flutter_github_app/redux/login_redux.dart';
import 'package:flutter_github_app/redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static final String className = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginBloc {
  /// 渲染 登录和授权按钮
  _renderLoginAndOAuthButton() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TTFlexButton(
              text: TTLocalizations.i18n(context).loginText,
              color: Theme.of(context).primaryColor,
              textColor: TTColors.textWhite,
              fontSize: 16,
              onPress: login,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TTFlexButton(
              text: TTLocalizations.i18n(context).oauthText,
              color: Theme.of(context).primaryColor,
              textColor: TTColors.textWhite,
              fontSize: 16,
              onPress: oAuthLogin,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Positioned.fill(child: AnimatedBackground()),
              Positioned.fill(child: ParticleWidget(30)),
              Center(
                /// 防止 overflow 现象
                child: SafeArea(
                  /// 弹出键盘不遮挡
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      color: TTColors.cardWhite,
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image(
                              image: AssetImage(TTIcons.DEFAULT_USER_ICON),
                              width: 90.0,
                              height: 90.0,
                            ),
                            Padding(padding: const EdgeInsets.all(10.0)),
                            TTInputWidget(
                              hintText: TTLocalizations.i18n(context).loginUsernameHintText,
                              iconData: TTIcons.LOGIN_USER,
                              onChanged: (value) => _username = value,
                              controller: usernameController,
                            ),
                            Padding(padding: const EdgeInsets.all(10.0)),
                            TTInputWidget(
                              hintText: TTLocalizations.i18n(context).loginPasswordHintText,
                              iconData: TTIcons.LOGIN_PASSWORD,
                              obscureText: true,
                              onChanged: (value) => _password = value,
                              controller: passwordController,
                            ),
                            Padding(padding: const EdgeInsets.all(10.0)),
                            _renderLoginAndOAuthButton(),
                            Padding(padding: const EdgeInsets.all(15.0)),
                            InkWell(
                              onTap: () => CommonUtils.showLanguageDialog(context),
                              child: Text(
                                TTLocalizations.i18n(context).switchLanguage,
                                style: TextStyle(color: TTColors.subTextColor),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(15.0))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

mixin LoginBloc on State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var _username = '';
  var _password = '';

  initParams() async {
    _username = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PASS_WORD_KEY);
    usernameController.value = TextEditingValue(text: _username ?? '');
    passwordController.value = TextEditingValue(text: _password ?? '');
  }

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.removeListener(_usernameChange);
    passwordController.removeListener(_passwordChange);
  }

  _usernameChange() {
    _username = usernameController.text;
  }

  _passwordChange() {
    _password = passwordController.text;
  }

  /// 登录
  login() async {
    Fluttertoast.showToast(
      msg: TTLocalizations.i18n(context).loginDeprecated,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
    );
    return;

    // if (_userName == null || _userName.isEmpty) {
    //   return;
    // }
    // if (_password == null || _password.isEmpty) {
    //   return;
    // }
    //
    /// 通过 redux 去执行登陆流程
    // StoreProvider.of<GSYState>(context)
    //     .dispatch(LoginAction(context, _userName, _password));
  }

  /// 授权登录
  oAuthLogin() async {
    String code = await NavigatorUtils.pushLoginWebView(
      context,
      Address.getOAuthUrl(),
      TTLocalizations.i18n(context).oauthText,
    );

    if (code != null && code.length > 0) {
      /// 通过 redux 去执行登录流程
      StoreProvider.of<TTState>(context).dispatch(OAuthAction(context, code));
    }
  }
}
