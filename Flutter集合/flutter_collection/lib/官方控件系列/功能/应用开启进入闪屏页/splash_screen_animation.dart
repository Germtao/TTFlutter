import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreenAnimation extends StatefulWidget {
  @override
  _SplashScreenAnimationState createState() => _SplashScreenAnimationState();
}

class _SplashScreenAnimationState extends State<SplashScreenAnimation> with SingleTickerProviderStateMixin {
  AnimationController _controller; // 控制动画的控制器
  Animation _animation; // 控制动画

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _animation = Tween(begin: 0.2, end: 1.0).animate(_controller);

    // 动画添加状态监听
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (route) => route == null);
      }
    });

    // 播放动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // 销毁动画
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Image.network(
        'http://img5.mtime.cn/mt/2019/09/20/110107.58871308_180X260X4.jpg',
        scale: 2.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
