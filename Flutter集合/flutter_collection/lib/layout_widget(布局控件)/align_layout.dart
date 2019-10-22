import 'package:flutter/material.dart';

// 对齐与相对定位
// Align 组件可以调整子组件的位置，并且可以根据子组件的宽高来确定自身的的宽高
class AlignLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('对齐与相对定位'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
//        height: 120.0,
//        width: 120.0,
            color: Colors.blue[50],
            child: Align(
              widthFactor: 2.0,
              heightFactor: 2.0,
              alignment: Alignment.topRight,
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.red
            ),
            child: Center(
              child: Text('xxx'),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Text('xxx'),
            ),
          ),
        ],
      ),
    );
  }
}

// Align 和 Stack 对比
// 1. 定位参考系统不同；Stack/Positioned定位的的参考系可以是父容器矩形的四个顶点；
//    而Align则需要先通过alignment 参数来确定坐标原点，不同的alignment会对应不同原点，
//    最终的偏移是需要通过alignment的转换公式来计算出。
// 2. Stack可以有多个子元素，并且子元素可以堆叠，而Align只能有一个子元素，不存在堆叠