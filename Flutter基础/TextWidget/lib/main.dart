import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Widget',
      home: Scaffold(
        body: Center(
          child: Text(
            'Hello Text Widget is a basic widget. textAlign maxLines overFlow property',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 25, color: Color.fromARGB(255, 255, 125, 255)),
          ),
        ),
      ),
    );
  }
}
