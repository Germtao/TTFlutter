import 'package:flutter/material.dart';

/// 从正方形逐渐变成圆形的动画
class TransformAnimationDemo extends StatefulWidget {
  @override
  _TransformAnimationDemoState createState() => _TransformAnimationDemoState();
}

class _TransformAnimationDemoState extends State<TransformAnimationDemo> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = BorderRadiusTween(
      begin: BorderRadius.circular(0.0),
      end: BorderRadius.circular(100.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _animation.value,
                  color: Colors.blue,
                ),
                width: 200.0,
                height: 200.0,
                child: Center(
                  child: Text(_animation.value.toString()),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
