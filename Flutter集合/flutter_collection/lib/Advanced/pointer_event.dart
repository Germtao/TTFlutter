import 'package:flutter/material.dart';

// 原始指针事件处理
class PointerEventTestRoute extends StatefulWidget {
  @override
  _PointerEventTestRouteState createState() => _PointerEventTestRouteState();
}

class _PointerEventTestRouteState extends State<PointerEventTestRoute> {
  PointerEvent _event; // 定义一个状态，保存当前指针位置
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blueAccent),
      child: Scaffold(
        appBar: AppBar(title: Text('原始指针事件处理')),
        body: Listener(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue,
            width: 300.0,
            height: 150.0,
            child: Text(
              _event?.toString() ?? "",
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPointerDown: (event) => setState(() => _event = event),
          onPointerMove: (event) => setState(() => _event = event),
          onPointerUp: (event) => setState(() => _event = event),
        ),
      ),
    );
  }
}
