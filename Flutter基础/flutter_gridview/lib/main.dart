import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: new AppBar(title: new Text('GridView Widget'),),
        body: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(20.0),
          crossAxisSpacing: 10.0,
          children: <Widget>[
            const Text('我是练习时长两年半的周琦', style: TextStyle(backgroundColor: Colors.red),),
            const Text('我喜欢唱', style: TextStyle(backgroundColor: Colors.deepPurple, color: Colors.white),),
            const Text('我喜欢跳', style: TextStyle(fontSize: 18.0, color: Colors.greenAccent, backgroundColor: Colors.black54),),
            const Text('我喜欢rap'),
            const Text('我喜欢🏀')
          ],
        ),
      ),
    );
  }
}