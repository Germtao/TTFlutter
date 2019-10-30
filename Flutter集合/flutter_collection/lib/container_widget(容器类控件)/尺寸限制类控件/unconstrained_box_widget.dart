import 'package:flutter/material.dart';

// UnconstrainedBox 不会对子组件产生任何限制，它允许其子组件按照其本身大小绘制
class UnConstrainedBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnconstrainedBox'),
        actions: <Widget>[
          UnconstrainedBox(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Colors.white70),
              ),
            ),
          ),
        ],
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 60.0, minHeight: 200.0), // 仍然有效
        child: UnconstrainedBox(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 90.0, minHeight: 50.0),
            child: redBox,
          ),
        ),
      ),
    );
  }

  Widget redBox = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
  );
}
