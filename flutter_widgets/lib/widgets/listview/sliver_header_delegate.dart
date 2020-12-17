import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as Math;

typedef Widget Builder(BuildContext context, double shrinkOffset, bool overlapsContent);

/// 动态头部处理
class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Builder builder;
  final bool changeSize;
  final TickerProvider vSync;
  final FloatingHeaderSnapConfiguration snapConfig;
  AnimationController animationController;

  SliverHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.snapConfig,
    @required this.vSync,
    this.child,
    this.builder,
    this.changeSize = false,
  });
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (builder != null) {
      return builder(context, shrinkOffset, overlapsContent);
    }
    return child;
  }

  @override
  double get maxExtent => Math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  TickerProvider get vsync => vSync;

  FloatingHeaderSnapConfiguration get snapConfiguration => snapConfig;
}
