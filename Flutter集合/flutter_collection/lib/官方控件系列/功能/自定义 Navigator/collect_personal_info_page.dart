import 'package:flutter/material.dart';

class CollectPersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline4,
      child: GestureDetector(
        onTap: () {
          // 这将从个人信息页面移至凭据页面,
          // 用该页面替换另外页面。
          Navigator.of(context).pushReplacementNamed('signup/choose_credentials');
        },
        child: Container(
          color: Colors.lightBlue,
          alignment: Alignment.center,
          child: Text('Collect Personal Info Page.'),
        ),
      ),
    );
  }
}
