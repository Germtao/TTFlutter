import 'package:flutter/material.dart';

// 流式布局
class WrapAndFloxLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('流式布局'),
      ),
      body: Wrap(
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
    );
  }
}
