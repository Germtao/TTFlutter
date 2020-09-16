import 'package:flutter/material.dart';
import 'collect_personal_info_page.dart';
import 'choose_credentials_page.dart';

class CustomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 构建自己的导航器，最终将其嵌套在我们的应用中导航
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Navigator'),
      ),
      body: Navigator(
        initialRoute: 'signup/personal_info',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case 'signup/personal_info':
              builder = (_) => CollectPersonalInfoPage();
              break;
            case 'signup/choose_credentials':

              /// 假设[ChooseCredentialsPage]收集新的凭据
              /// 然后调用[onSignupComplete()]
              builder = (_) => ChooseCredentialsPage(
                    onSignUpComplete: () {
                      /// 从此处引用[Navigator.of(context)]指的是顶级导航器
                      /// 因为[CustomNavigator]在它创建的嵌套导航器
                      /// 因此，此[pop()]将弹出整个[CustomNavigator]并返回到["/"]路线，也称为HomePage
                      Navigator.of(context).pop();
                    },
                  );
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}
