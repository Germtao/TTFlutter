import 'package:flutter/material.dart';

// 按钮控件
class ButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('按钮'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // 漂浮按钮: 默认带有阴影和灰色背景, 按下后, 阴影会变大
            RaisedButton(
              child: Text('Normal'),
              onPressed: () {},
            ),
            // 扁平按钮: 默认背景透明并不带阴影, 按下后, 会有背景色
            FlatButton(
              child: Text(
                'Normal',
                style: TextStyle(color: Colors.black),
              ),
              highlightColor: Colors.grey,
              onPressed: () {},
            ),
            // 默认有一个边框, 不带阴影且背景透明
            OutlineButton(
              child: Text(
                'Normal',
                style: TextStyle(color: Colors.blue),
              ),
              borderSide: BorderSide(color: Colors.grey),
              onPressed: () {},
            ),
            // 一个可点击Icon, 不包括文字, 默认没有背景, 点击会出现背景
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: Colors.black,
              ),
              onPressed: () {},
            ),

            // 带图标的按钮
            RaisedButton.icon(
              icon: Icon(Icons.send),
              label: Text('发送'),
              onPressed: () {},
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: Text('添加'),
              textColor: Colors.black,
              onPressed: () {},
            ),
            OutlineButton.icon(
              icon: Icon(Icons.info),
              label: Text('详情'),
              color: Colors.black,
              textColor: Colors.black,
              borderSide: BorderSide(color: Colors.grey),
              onPressed: () {},
            ),

            // 自定义按钮外观
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue, // 按钮背景颜色
                  highlightColor: Colors.blue[700], // 按钮按下时的背景颜色
                  colorBrightness: Brightness.dark, // 按钮主题，默认是浅色主题
                  splashColor: Colors.grey, // 点击时，水波动画中水波的颜色
                  child: Text('提交'), // 按钮的内容
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 外形
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  // color: Color(0x000000), // 按钮背景颜色
                  highlightColor: Colors.blue[700], // 按钮按下时的背景颜色
                  colorBrightness: Brightness.dark, // 按钮主题，默认是浅色主题
                  splashColor: Colors.grey, // 点击时，水波动画中水波的颜色
                  child: Text('提交'), // 按钮的内容
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 外形
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
