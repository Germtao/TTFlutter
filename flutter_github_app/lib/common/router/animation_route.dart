import 'package:flutter/material.dart';

/// 动画大小变化打开的路由
class SizeRoute extends PageRouteBuilder {
  final Widget widget;

  SizeRoute({this.widget})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              widget,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
}

class NoAnimationRoute extends PageRouteBuilder {
  final Widget widget;

  NoAnimationRoute({this.widget})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
