import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 原理：
/// 只要使用了[CupertinoPageRoute]push进来的页面就都会具有右滑返回的操作
class SwipeRightBackDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          color: CupertinoColors.black,
          child: CupertinoButton(
            child: Icon(CupertinoIcons.add),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return SwipeRightBackDemo();
              }));
            },
          ),
        ),
      ),
    );
  }
}
