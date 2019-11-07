import 'package:flutter/material.dart';

// 单选框和复选框
class SwitchAndCheckBoxWidget extends StatefulWidget {
  @override
  _SwitchAndCheckBoxWidgetState createState() =>
      _SwitchAndCheckBoxWidgetState();
}

class _SwitchAndCheckBoxWidgetState extends State<SwitchAndCheckBoxWidget> {
  bool _switchSelected = true; // 记录单选开关状态
  bool _checkboxSelected = true; // 记录复选框状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('单选框和复选框'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 单选框
            Switch(
              value: _switchSelected,
              onChanged: (value) {
                setState(() {
                  _switchSelected = value;
                });
              },
            ),

            // 复选框
            Checkbox(
              value: _checkboxSelected,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  _checkboxSelected = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
