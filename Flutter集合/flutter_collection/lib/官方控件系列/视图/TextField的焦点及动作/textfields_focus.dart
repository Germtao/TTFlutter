import 'package:flutter/material.dart';

/// 实现原理:
/// 使用[FocusNode]获取当前[textField]焦点
/// 在[TextNode]的[textInputAction]属性中选择键盘[action（next/down）]
/// 对于[最后一个之前]的[TextField]：在[onSubmitted]属性中解除当前[focus]状态
/// 再聚焦[下一个][FocusNode]:[FocusScope.of(context).requestFocus( nextFocusNode )]
/// 对于[最后一个TextField],直接解除[focus]并提交表单
class TextFieldFocusDemo extends StatefulWidget {
  TextFieldFocusDemo({Key key}) : super(key: key);

  @override
  _TextFieldFocusDemoState createState() => _TextFieldFocusDemoState();
}

class _TextFieldFocusDemoState extends State<TextFieldFocusDemo> {
  TextEditingController _nameController, _pwdController;
  FocusNode _nameFocus, _pwdFocus;

  @override
  void initState() {
    _nameController = TextEditingController();
    _pwdController = TextEditingController();
    _nameFocus = FocusNode();
    _pwdFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 80.0),
            Center(
              child: Text(
                '登录',
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            const SizedBox(height: 80.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (input) {
                    _nameFocus.unfocus();
                    FocusScope.of(context).requestFocus(_pwdFocus);
                  },
                  decoration: InputDecoration(labelText: '账号'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  focusNode: _pwdFocus,
                  controller: _pwdController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (input) {
                    _pwdFocus.unfocus();
                    // 登录请求
                    print('请求登录');
                  },
                  decoration: InputDecoration(labelText: '密码'),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            ButtonBar(
              children: [
                RaisedButton(
                  onPressed: () {},
                  child: Text('登录'),
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
