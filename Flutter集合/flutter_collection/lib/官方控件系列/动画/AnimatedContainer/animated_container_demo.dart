import 'package:flutter/material.dart';

/// [AnimationContainer]使用要点
/// 必须传入[Duration]告诉动画的播放时间
/// 当[animationContainer]接收到一个新的值的时候
/// 会根据老值进行补间动画
///
/// 例如: 开始宽高为100，然后给了新值0并setState后
/// AnimationContainer会让宽高从100逐渐变化到0
/// 其中变化曲线由[Curve]决定，默认为Curves.linear
class AnimatedContainerDemo extends StatefulWidget {
  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  double _value = 255.0;

  _changeValue() => setState(() {
        _value = _value == 255.0 ? 80.0 : 255.0;
        print(_value);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: _changeValue,
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.decelerate,
            width: _value,
            height: _value,
            child: FlutterLogo(),
          ),
        ),
      ),
    );
  }
}
