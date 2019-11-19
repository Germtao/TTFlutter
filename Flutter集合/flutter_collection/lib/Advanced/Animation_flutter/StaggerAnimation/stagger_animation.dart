import 'package:flutter/material.dart';
import 'stagger.dart';

class StaggerAnimationTestRoute extends StatefulWidget {
  @override
  _StaggerAnimationTestRouteState createState() =>
      _StaggerAnimationTestRouteState();
}

class _StaggerAnimationTestRouteState extends State<StaggerAnimationTestRoute>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  // 播放动画
  Future<Null> _playAnimation() async {
    try {
      // 先正向执行动画
      await _controller.forward().orCancel;
      // 再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // 动画被取消了, 可能是因为被释放了
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('交织动画')),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _playAnimation();
          },
          child: Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              // 调用我们定义的交织动画Widget
              child: StaggerAnimation(
                controller: _controller,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
