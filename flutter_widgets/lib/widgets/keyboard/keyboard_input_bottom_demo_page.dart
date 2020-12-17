import 'package:flutter/material.dart';
import './keyboard_detector.dart';

class KeyboardInputBottomDemoPage extends StatefulWidget {
  @override
  _KeyboardInputBottomDemoPageState createState() => _KeyboardInputBottomDemoPageState();
}

class _KeyboardInputBottomDemoPageState extends State<KeyboardInputBottomDemoPage> {
  bool isKeyboardShowing = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDetector(
      keyboardShowCallback: (show) {
        setState(() {
          isKeyboardShowing = show;
        });
      },
      content: Scaffold(
        appBar: AppBar(
          title: Text('键盘顶起展示（仅 App）'),
        ),
        body: GestureDetector(
          // 透明可以触摸
          behavior: HitTestBehavior.translucent,
          // 点击 收起键盘
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SafeArea(
            child: Container(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('测试，测试，测试，测试，测试，测试，测试，测试，测试，测试，测试，测试，测试，测试，测试'),
                  ),
                  _getAlign(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getAlign() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '请输入',
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0)),
                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0)),
                  border: UnderlineInputBorder(borderSide: BorderSide(width: 0)),
                ),
                controller: textEditingController,
              ),
            ),
            Visibility(
              visible: isKeyboardShowing,
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey,
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Text('bottom bar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
