import 'package:flutter/material.dart';

// 手势识别
class GestureTestRoute extends StatefulWidget {
  @override
  _GestureTestRouteState createState() => _GestureTestRouteState();
}

class _GestureTestRouteState extends State<GestureTestRoute> {
  String _operation = "No Gesture detected!"; // 保存事件名

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blueAccent),
      child: Scaffold(
        appBar: AppBar(title: Text('手势识别')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _tap(),
            ],
          ),
        ),
      ),
    );
  }

  // GestureDetector
  // 单击、双击、长按
  Widget _tap() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        width: 200.0,
        height: 100.0,
        child: Text(
          _operation,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: () => updateText('单击'),
      onDoubleTap: () => updateText('双击'),
      onLongPress: () => updateText('长按'),
    );
  }

  void updateText(String text) {
    setState(() {
      _operation = text;
    });
  }
}
