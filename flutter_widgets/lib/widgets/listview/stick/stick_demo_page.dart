import 'package:flutter/material.dart';
import 'stick_widget.dart';

class StickDemoPage extends StatefulWidget {
  @override
  _StickDemoPageState createState() => _StickDemoPageState();
}

class _StickDemoPageState extends State<StickDemoPage> {
  _buildStickHeader(int index) {
    return Container(
      height: 50,
      color: Colors.deepPurpleAccent,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => print('stick header $index.'),
        child: Text(
          '我的 $index 的头啊',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  _buildStickContent(int index) {
    return InkWell(
      onTap: () => print('stick content $index.'),
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 10),
        color: Colors.pinkAccent,
        child: Center(
          child: Text(
            '我的 $index 内容啊',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StickDemoPage'),
      ),
      body: Container(
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 200,
              color: Colors.deepOrangeAccent,
              child: StickWidget(
                stickHeader: _buildStickHeader(index),
                stickContent: _buildStickContent(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
