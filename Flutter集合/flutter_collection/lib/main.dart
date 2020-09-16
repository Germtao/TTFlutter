import 'package:flutter/material.dart';
import 'collection_page.dart';
import './官方控件系列/功能/在不同页面传递事件EventBus/index.dart';

void main() {
  runApp(FlutterDemo());
  behaviorBus.fire(CountEvent(0));
}

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
