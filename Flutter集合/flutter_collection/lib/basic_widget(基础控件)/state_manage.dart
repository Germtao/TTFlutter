import 'package:flutter/material.dart';

// 状态管理
class StateManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('状态管理'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Widget管理自身状态'),
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }
}
