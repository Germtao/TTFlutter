import 'package:flutter/material.dart';
import 'WarpLayout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Layout',
      theme: ThemeData.light(),
      home: WarpLayout(),
    );
  }
}
