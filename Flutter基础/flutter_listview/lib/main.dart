import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List View Widget',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List View Widget'),
        ),
        body: Center(
          child: Container(
            height: 200.0,
            child: MyList(),
          ),
        ),
      ),
    );
  }
}

class MyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        new Container(width: 180.0, color: Colors.lightBlue,),
        new Container(width: 180.0, color: Colors.deepOrangeAccent,),
        new Container(width: 180.0, color: Colors.deepPurple,),
        new Container(width: 180.0, color: Colors.lightGreenAccent,),
      ],
    );
  }
}