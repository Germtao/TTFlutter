import 'package:flutter/material.dart';

// 输入框控件
class TextFieldWidget extends StatefulWidget {
  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  // 监听焦点状态改变事件
  // FocusNode继承自ChangeNotifier
  // 通过FocusNode可以监听焦点的改变事件
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
  FocusScopeNode scopeNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('输入框和表单'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true, // 是否自动获取焦点
              focusNode: node1, // 关联node1
              // 用于控制TextField的外观显示，如提示文本、背景颜色、边框等
              decoration: InputDecoration(
                labelText: '用户名',
                hintText: '请输入手机或邮箱',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              focusNode: node2,
              decoration: InputDecoration(
                labelText: '密码',
                hintText: '请输入密码',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true, // 是否隐藏正在编辑的文本
            ),
            Builder(
              builder: (ctx) {
                return Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('移动焦点'),
                      onPressed: () {
                        //将焦点从第一个TextField移到第二个TextField
                        // 1. 这是一种写法
                        // FocusScope.of(context).requestFocus(node2);
                        // 2. 这是第二种写法
                        if (null == scopeNode) {
                          scopeNode = FocusScope.of(context);
                        }
                        scopeNode.requestFocus(node2);
                      },
                    ),
                    RaisedButton(
                      child: Text('隐藏键盘'),
                      onPressed: () {
                        // 当所有编辑框都失去焦点时键盘就会收起
                        node1.unfocus();
                        node2.unfocus();
                      },
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
