import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Column Widget Demo',
      home: Scaffold(
        appBar: new AppBar(title: new Text('垂直方向布局'),),
        body: new Center(
          child: MyColumn(),
        ),
      ),
    );
  }
}

class MyColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new RaisedButton(
          onPressed: (){},
          color: Colors.orangeAccent,
          child: new Text('Orange Button'),
        ),
        new Text(
          '我喜欢唱、跳、rap、🏀',
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
              backgroundColor: Colors.deepPurple),
        ),
        new RaisedButton(
          onPressed: (){},
          color: Colors.redAccent,
          child: new Text('Red Button'),
        ),
      ],
    );
  }
}