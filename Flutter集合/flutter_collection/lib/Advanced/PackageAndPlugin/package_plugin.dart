import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BatterylevelTestRoute extends StatefulWidget {
  @override
  _BatterylevelTestRouteState createState() => _BatterylevelTestRouteState();
}

class _BatterylevelTestRouteState extends State<BatterylevelTestRoute> {

  static const platform = const MethodChannel('samples.flutter.io/battery');

  // 获取电池电量
  String _batterylevel = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    String batterylevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batterylevel = '电池电量 $result % .';
    } on PlatformException catch (e) {
      batterylevel = "获取电池电量错误: '${e.message}'.";
    }

    setState(() {
      _batterylevel = batterylevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('包和插件'),
      ),
      body: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('获取电池电量'),
                onPressed: _getBatteryLevel,
              ),
              Text(_batterylevel)
            ],
          ),
        ),
      ),
    );
  }
}