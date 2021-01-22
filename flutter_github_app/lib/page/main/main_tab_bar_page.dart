import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/style/style.dart';

class MainTabBarPage extends StatefulWidget {
  MainTabBarPage({Key key}) : super(key: key);

  @override
  _MainTabBarPageState createState() => _MainTabBarPageState();
}

class _MainTabBarPageState extends State<MainTabBarPage> {
  final ScrollController scrollController = ScrollController();

  String beStaredCount = '---';

  Color notifyColor = TTColors.subTextColor;

  // Store

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
