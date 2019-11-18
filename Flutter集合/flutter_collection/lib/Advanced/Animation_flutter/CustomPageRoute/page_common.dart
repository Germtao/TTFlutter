import 'package:flutter/material.dart';

class PageTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('跳转页')),
        body: Container(),
      ),
    );
  }
}
