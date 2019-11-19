import 'package:flutter/material.dart';
import 'package:flutter_collection/Advanced/Animation_flutter/AnimatedSwitcher/custom_slide.dart';
import 'package:flutter_collection/Advanced/Animation_flutter/AnimatedSwitcher/slide_transition_x.dart';

class AnimatedSwitcherCounterRoute extends StatefulWidget {
  @override
  _AnimatedSwitcherCounterRouteState createState() =>
      _AnimatedSwitcherCounterRouteState();
}

class _AnimatedSwitcherCounterRouteState
    extends State<AnimatedSwitcherCounterRoute> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('通用切换动画控件')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                // 执行缩放动画
                // return ScaleTransition(
                //   child: child,
                //   scale: animation,
                // );

                // return CustomSlideTransition(
                //   child: child,
                //   position:
                //       Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                //           .animate(animation),
                // );

                return SlideTransitionX(
                  child: child,
                  direction: AxisDirection.down, // 上入下出
                  position: animation,
                );
              },
              child: Text(
                '$_count',
                // 显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                key: ValueKey<int>(_count),
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            RaisedButton(
              child: Text('+1'),
              onPressed: () {
                setState(() => _count += 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
