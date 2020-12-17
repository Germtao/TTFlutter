import 'package:flutter/material.dart';
import './keyboard_detector.dart';

/// 键盘是否弹起
class KeyboardDemoPage extends StatefulWidget {
  @override
  _KeyboardDemoPageState createState() => _KeyboardDemoPageState();
}

class _KeyboardDemoPageState extends State<KeyboardDemoPage> {
  bool isKeyboardShowing = false;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // 必须镶嵌在最外层
    return KeyboardDetector(
      content: getContent(context),
      keyboardShowCallback: (isKeyboardShowing) {
        setState(() {
          this.isKeyboardShowing = isKeyboardShowing;
        });
      },
    );
  }

  getContent(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KeyboardDemoPage'),
      ),
      body: GestureDetector(
        // 透明可点击
        behavior: HitTestBehavior.translucent,
        // 触摸收起键盘
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    isKeyboardShowing ? '键盘弹起' : '键盘未弹起',
                    style: TextStyle(
                      color: isKeyboardShowing ? Colors.redAccent : Colors.greenAccent,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: FlatButton(
                    onPressed: () {
                      if (!isKeyboardShowing) {
                        // 触摸弹起键盘
                        FocusScope.of(context).requestFocus(_focusNode);
                      }
                    },
                    child: Text('弹出键盘'),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    focusNode: _focusNode,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
