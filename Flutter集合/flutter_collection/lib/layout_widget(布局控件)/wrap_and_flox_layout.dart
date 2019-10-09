import 'package:flutter/material.dart';

// 流式布局
class WrapAndFloxLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('流式布局'),
      ),
      body: Column(
        children: <Widget>[
          Wrap(
            spacing: 8.0, // 主轴（水平）方向间距
            runSpacing: 4.0, // 纵轴（垂直）方向间距
            alignment: WrapAlignment.center, // 沿主轴方向居中
            children: <Widget>[
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('M'),
                ),
                label: Text('冒险王'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('P'),
                ),
                label: Text('苹果爸爸'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('A'),
                ),
                label: Text('阿里巴巴'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text('H'),
                ),
                label: Text('华为爸爸'),
              ),
            ],
          ),
          Flow(
            delegate: CustomFlowDelegate(margin: EdgeInsets.all(10.0)),
            children: <Widget>[
              Container(width: 80.0, height: 80.0, color: Colors.red),
              Container(width: 80.0, height: 80.0, color: Colors.blue),
              Container(width: 80.0, height: 80.0, color: Colors.green),
              Container(width: 80.0, height: 80.0, color: Colors.yellow),
              Container(width: 80.0, height: 80.0, color: Colors.purple),
              Container(width: 80.0, height: 80.0, color: Colors.brown),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;
  CustomFlowDelegate({this.margin});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    // 计算每一个widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        // 绘制子widget（有优化）
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // 指定Flow的大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
