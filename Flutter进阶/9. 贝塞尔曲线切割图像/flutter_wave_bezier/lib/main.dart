import 'package:flutter/material.dart';
import 'wave_bezier_curve.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wave Bezier Curve',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
