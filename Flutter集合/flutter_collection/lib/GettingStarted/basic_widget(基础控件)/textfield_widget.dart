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
            // 自定义输入框
            Theme(
              data: Theme.of(context).copyWith(
                hintColor: Colors.grey[200], // 定义下划线颜色
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.grey), // 定义label字体样式
                  hintStyle: TextStyle(
                    // 定义提示字体样式
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ),
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
                ],
              ),
            ),
            // 灵活的方式是直接隐藏掉TextField本身的下划线，然后通过Container去嵌套定义样式
            Container(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: '邮箱',
                  hintText: '电子邮件地址',
                  prefixIcon: Icon(Icons.email),
                  hintStyle: TextStyle(fontSize: 13.0),
                  border: InputBorder.none, // 隐藏下划线
                ),
              ),
              decoration: BoxDecoration(
                // 下划线颜色灰色, 宽度1像素
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
              ),
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
                    RaisedButton(
                      child: Text('表单'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FormWidget()));
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

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  // 编辑框的控制器，通过它可以设置/获取编辑框的内容、选择编辑内容、监听编辑文本改变事件
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // Form的State类，可以通过Form.of()或GlobalKey获得
  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('表单'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          key: _formKey, // 设置globalKey，用于后面获取FormState
          // autovalidate: true, // 开启自动校验
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '用户名',
                  hintText: '请输入用户名或邮箱',
                  icon: Icon(Icons.person),
                ),
                // 用户名校验
                validator: (v) {
                  return v.trim().length > 0 ? null : '用户名不能为空';
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '密码',
                  hintText: '请输入密码',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) {
                  return v.trim().length > 5 ? null : '密码不能少于6位';
                },
              ),
              // 登录按钮
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          '登 录',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        color: Theme.of(context).textSelectionColor,
                        textColor: Colors.black,
                        onPressed: () {
                          // 通过_formKey.currentState 获取FormState后
                          // 调用validate()方法校验用户名密码是否合法
                          // 校验通过后再提交数据
                          if ((_formKey.currentState as FormState).validate()) {
                            print('验证通过提交数据');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
