import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 实现原理:
/// 利用[form]自带的[onWillPop]属性，其余与[will_pop_scope_demo]中一致
class FormPopDemo extends StatefulWidget {
  @override
  _FormPopDemoState createState() => _FormPopDemoState();
}

class _FormPopDemoState extends State<FormPopDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _colors = ['', 'red', 'green', 'blue', 'orange'];

  String _color = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('返回上一页时弹出提示信息 - Form'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          onWillPop: _onBackPressed,
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: '输入您的姓名',
                  labelText: '姓名',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  hintText: '输入您的出生日期',
                  labelText: '出生日期',
                ),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: '输入电话号码',
                  labelText: '电话号码',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: '输入邮箱',
                  labelText: '邮箱',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.color_lens),
                  labelText: '颜色',
                ),
                isEmpty: _color == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _color,
                    isDense: true,
                    onChanged: (newValue) {
                      setState(() {
                        _color = newValue;
                      });
                    },
                    items: _colors.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: RaisedButton(
                  child: Text('提交'),
                  onPressed: null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('您真的要退出该应用程序吗？'),
        actions: [
          FlatButton(
            child: Text('否'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('是'),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      ),
    );
  }
}
