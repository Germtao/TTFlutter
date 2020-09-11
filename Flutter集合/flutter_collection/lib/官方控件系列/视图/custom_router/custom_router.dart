import 'package:flutter/material.dart';

class CustomRoute extends PageRouteBuilder {
  final Widget widget;

  CustomRoute(this.widget)
      : super(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondyAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondyAnimation,
              Widget child) {
            // 淡出过渡路由
            // return FadeTransition(
            //   opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //       parent: animation, curve: Curves.fastOutSlowIn)),
            //   child: child,
            // );

            // 缩放路由
            // return ScaleTransition(
            //   scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //       parent: animation, curve: Curves.fastOutSlowIn)),
            //   child: child,
            // );

            // 旋转 + 缩放路由
            // return RotationTransition(
            //   turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //       parent: animation, curve: Curves.fastLinearToSlowEaseIn)),
            //   child: ScaleTransition(
            //     scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //         parent: animation, curve: Curves.fastOutSlowIn)),
            //     child: child,
            //   ),
            // );

            // 幻灯片路由
            return SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          curve: Curves.fastOutSlowIn, parent: animation)),
              child: child,
            );
          },
        );
}
