import 'package:flutter/material.dart';

// 对话框带复选框
class DialogCheckBox extends StatefulWidget {
  DialogCheckBox({
    Key key,
    this.value,
    @required this.onChanged,
  });

  final ValueChanged<bool> onChanged;
  final bool value;
  @override
  _DialogCheckBoxState createState() => _DialogCheckBoxState();
}

class _DialogCheckBoxState extends State<DialogCheckBox> {
  bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (v) {
        // 将选中状态通过事件的形式抛出
        widget.onChanged(v);
        setState(() {
          // 更新自身选中状态
          value = v;
        });
      },
    );
  }
}
