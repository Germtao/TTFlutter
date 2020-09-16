import 'package:flutter/material.dart';
import './custom_navigator.dart';

class CustomNavigatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for Navigator',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => CustomNavigatorHomePage(),
        '/signup': (BuildContext context) => CustomNavigator(),
      },
    );
  }
}

class CustomNavigatorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline4,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/signup'),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('Custom Navigator Home Page.'),
        ),
      ),
    );
  }
}
