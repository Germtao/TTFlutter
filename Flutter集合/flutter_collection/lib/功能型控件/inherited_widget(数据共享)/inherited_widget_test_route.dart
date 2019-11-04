import 'package:flutter/material.dart';
import 'package:flutter_collection/功能型控件/inherited_widget(数据共享)/share_data_widget.dart';
import 'package:flutter_collection/功能型控件/inherited_widget(数据共享)/share_data_test_widget.dart';

class InheritedWidgetTestRoute extends StatefulWidget {
  @override
  _InheritedWidgetTestRouteState createState() =>
      _InheritedWidgetTestRouteState();
}

class _InheritedWidgetTestRouteState extends State<InheritedWidgetTestRoute> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数据共享'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ShareDataWidget(
          data: count,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ShareDataTestWidget(), // 子widget中依赖ShareDataWidget
              ),
              RaisedButton(
                child: Text('Increment'),
                // 每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
                onPressed: () => setState(() => ++count),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
