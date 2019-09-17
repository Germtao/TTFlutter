import 'package:flutter/material.dart';
import 'flutter_search_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar',
      theme: ThemeData.light(),
      home: SearchBar(),
    );
  }
}
