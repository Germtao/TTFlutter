import 'package:flutter/material.dart';

// 多重限制
class MultipleLimitBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('多重限制'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 100.0, minHeight: 100.0), // 父
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 200.0, minHeight: 50.0), // 子
          child: redBox,
        ),
      ),
    );
  }

  Widget redBox = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
  );
}
