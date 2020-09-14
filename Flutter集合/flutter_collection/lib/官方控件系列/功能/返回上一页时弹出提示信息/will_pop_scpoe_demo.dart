import 'package:flutter/material.dart';

/// 实现原理，使用[WillPopScope]组件，它会检测到子组件的[Navigation]的[pop]事件，并拦截下来。
/// 我们需要在它的[onWillPop]属性中返回一个新的组件（一般是一个Dialog）处理是否真的pop该页面。
class WillPopScpoeDemo extends StatefulWidget {
  final String title;

  WillPopScpoeDemo({Key key, this.title}) : super(key: key);

  @override
  _WillPopScpoeDemoState createState() => _WillPopScpoeDemoState();
}

class _WillPopScpoeDemoState extends State<WillPopScpoeDemo> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('您已多次按下按钮：'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: '增量',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('您真的要退出该应用程序吗？'),
              actions: [
                FlatButton(
                  child: Text('否'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text('是'),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }
}
