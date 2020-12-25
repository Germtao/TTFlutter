import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/utils/navigator_utils.dart';

class HomeDrawer extends StatelessWidget {
  showAboutDialog(BuildContext context, String versionName) {
    versionName ??= 'null';
    NavigatorUtils.showTTDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: ,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
