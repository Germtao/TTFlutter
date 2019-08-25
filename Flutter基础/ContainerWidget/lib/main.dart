import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Container Widget',
      home: Scaffold(
        body: Center(
          child: new Container(
            child:
                new Text('Hellp Container', style: TextStyle(fontSize: 40.0)),
            alignment: Alignment.topLeft,
            width: 500.0,
            height: 400.0,
            // color: Colors.lightBlue,
            padding: const EdgeInsets.fromLTRB(10.0, 100.0, 0.0, 0.0),
            margin: const EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.lightBlue, Colors.greenAccent, Colors.purple]
              ),
              border: Border.all(width: 5.0, color: Colors.black)
            ),
          ),
        ),
      ),
    );
  }
}
