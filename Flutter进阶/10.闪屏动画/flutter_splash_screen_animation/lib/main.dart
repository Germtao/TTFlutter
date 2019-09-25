import 'package:flutter/material.dart';
import 'splash_screen_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenAnimation(),
    );
  }
}
