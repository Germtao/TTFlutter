import 'package:flutter/material.dart';

typedef KeyboardShowCallback = void Function(bool isKeyboardShowing);

/// 监听键盘弹出、收起
class KeyboardDetector extends StatefulWidget {
  final KeyboardShowCallback keyboardShowCallback;

  final Widget content;

  KeyboardDetector({this.keyboardShowCallback, @required this.content});

  @override
  _KeyboardDetectorState createState() => _KeyboardDetectorState();
}

class _KeyboardDetectorState extends State<KeyboardDetector> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widget.keyboardShowCallback?.call(MediaQuery.of(this.context).viewInsets.bottom > 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.content;
  }
}
