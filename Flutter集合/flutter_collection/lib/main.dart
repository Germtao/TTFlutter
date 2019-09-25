import 'package:flutter/material.dart';
import 'collection_page.dart';

void main() => runApp(FlutterDemo());

class FlutterDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Collections',
      theme: ThemeData.dark(),
      home: CollectionPage(),
    );
  }
}
