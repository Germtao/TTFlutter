import 'package:flutter/material.dart';

// 导航返回拦截
class WillPopScopeTestRoute extends StatefulWidget {
  @override
  _WillPopScopeTestRouteState createState() => _WillPopScopeTestRouteState();
}

class _WillPopScopeTestRouteState extends State<WillPopScopeTestRoute> {
  DateTime _lastPressedAt; // 上次点击的时间

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('导航返回拦截'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 1)) {
            // 两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        },
        child: Container(
          alignment: Alignment.center,
          child: Text('1秒内连点两次返回键退出'),
        ),
      ),
    );
  }
}
