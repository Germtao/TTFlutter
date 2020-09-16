import 'package:flutter/material.dart';

/// 父子动画，动画中的子动画，父动画是按照X轴平移，子动画是上面的方块大小逐渐增大
class AnotherParentAnimationDemo extends StatefulWidget {
  @override
  _AnotherParentAnimationDemoState createState() => _AnotherParentAnimationDemoState();
}

class _AnotherParentAnimationDemoState extends State<AnotherParentAnimationDemo> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _parentAnimation, _childAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _parentAnimation = Tween(begin: -0.5, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _childAnimation = Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _parentAnimation,
      builder: (context, child) {
        return Scaffold(
          body: Transform(
            transform: Matrix4.translationValues(_parentAnimation.value * width, .0, .0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _childAnimation,
                    builder: (context, child) {
                      return Container(
                        color: Colors.lightBlue,
                        width: _childAnimation.value * 2,
                        height: _childAnimation.value,
                      );
                    },
                  ),
                  Container(
                    color: Colors.orange,
                    width: 200.0,
                    height: 100.0,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
