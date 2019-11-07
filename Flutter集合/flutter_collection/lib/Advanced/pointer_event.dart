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
        body: Stack(
          children: <Widget>[
            Listener(
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(Size(300.0, 200.0)),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.blue),
                ),
              ),
              onPointerDown: (event) => print('down - 0'),
            ),
            Listener(
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(Size(200.0, 100.0)),
                child: Center(
                  child: Text(
                    '左上角200*100范围内非文本区域点击',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onPointerDown: (event) => print('down - 1'),
              behavior: HitTestBehavior.translucent,
            ),
          ],
        ),
      ),
    );
  }
}
