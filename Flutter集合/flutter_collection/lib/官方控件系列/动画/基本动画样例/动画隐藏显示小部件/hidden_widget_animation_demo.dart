import 'package:flutter/material.dart';

/// 单击中间方块显示隐藏按钮，双击中间方块复原
class HiddenWidgetAnimationDemo extends StatefulWidget {
  @override
  _HiddenWidgetAnimationDemoState createState() => _HiddenWidgetAnimationDemoState();
}

class _HiddenWidgetAnimationDemoState extends State<HiddenWidgetAnimationDemo> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: -0.15).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RaisedButton(
                        onPressed: null,
                        child: Text('Buy'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 7.0,
                      ),
                      const SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: null,
                        child: Text('Detail'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 7.0,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _animationController.forward(),
                  onDoubleTap: () => _animationController.reverse(),
                  child: Center(
                    child: Container(
                      color: Colors.lightBlue,
                      alignment: Alignment.bottomCenter,
                      width: 200.0,
                      height: 80.0,
                      transform: Matrix4.translationValues(0.0, _animation.value * width, 0.0),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
