import 'package:flutter/material.dart';

// 线性布局
class LinearLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('线性布局'),
      ),
      body: Column(
        // 测试 Row 对齐方式, 排除 Column 默认居中对齐的干扰
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // 表示子组件在Row所占用的水平空间内对齐方式
            children: <Widget>[
              Text('Row 主轴居中对齐'),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min, // 表示Row在主轴(水平)方向占用的空间
            mainAxisAlignment: MainAxisAlignment.center, // 无意义
            children: <Widget>[
              Text('Row 主轴居中对齐'),
              Text('Row 主轴方向尽可能少占用'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            textDirection: TextDirection.rtl, // 表示水平方向子组件的布局顺序
            children: <Widget>[
              Text('textDirection是mainAxisAlignment的参考系'),
              Text('Row 从右往左布局'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // 子组件在纵轴方向的对齐方式
            verticalDirection: VerticalDirection.up, // Row纵轴（垂直）的对齐方向
            children: <Widget>[
              Text(
                'hello world',
                style: TextStyle(fontSize: 30.0),
              ),
              Text('Row 纵轴对齐方式'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('hey'),
              Text('Boy'),
            ],
          ),

          // 特殊情况
          Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max, // 有效, 外层Column高度占据Container
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    child: Column(
                      mainAxisSize: MainAxisSize.max, // 无效, 内层Column高度为实际高度
                      children: <Widget>[
                        Text('hello'),
                        Text('world'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
