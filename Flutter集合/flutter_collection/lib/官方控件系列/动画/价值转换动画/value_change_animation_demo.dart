import 'package:flutter/material.dart';

/// 从5倒数到0
class ValueChangeAnimationDemo extends StatefulWidget {
  @override
  _ValueChangeAnimationDemoState createState() => _ValueChangeAnimationDemoState();
}

class _ValueChangeAnimationDemoState extends State<ValueChangeAnimationDemo> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = IntTween(begin: 5, end: 0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double textSize = 56.0;
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Waiting...',
                style: TextStyle(fontSize: textSize),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Text(
                    _animation.value.toString(),
                    style: TextStyle(fontSize: textSize),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
