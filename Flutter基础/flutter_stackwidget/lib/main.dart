import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statck Widget',
      home: Scaffold(
        appBar: new AppBar(title: new Text('层叠布局'),),
        body: new Center(
          child: MyStack(),
        ),
      ),
    );
  }
}

class MyStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: const FractionalOffset(0.9, 0.5),
      children: <Widget>[
        new CircleAvatar(
          backgroundImage: new NetworkImage('http://img5.mtime.cn/CMS/News/2019/09/08/215707.17506241_620X620.jpg'),
          radius: 150.0,
        ),
        new Container(
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          padding: const EdgeInsets.all(5.0),
          child: new Text('🤡🤡🤡🤡🤡'),
        ),
      ],
    );
  }
}