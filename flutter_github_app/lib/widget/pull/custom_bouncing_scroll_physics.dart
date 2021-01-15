import 'dart:math';
import 'package:flutter/material.dart';

/// 自定义弹性滑动效果
class CustomBouncingScrollPhysics extends ScrollPhysics {
  final double refreshHeight;

  const CustomBouncingScrollPhysics({
    ScrollPhysics parent,
    this.refreshHeight = 140,
  }) : super(parent: parent);

  double frictionFactor(double overscrollFraction) => 0.52 * pow(1 - overscrollFraction, 2);

  static double _applyFriction(double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) {
        return absDelta * gamma;
      }
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0);
    assert(position.minScrollExtent <= position.maxScrollExtent);
    if (!position.outOfRange) return offset;

    final double overScrollPastStart = max(position.minScrollExtent - position.pixels, 0.0);
    final double overScrollPastEnd = max(position.pixels - position.maxScrollExtent, 0.0);
    final double overScrollPast = max(overScrollPastStart, overScrollPastEnd);

    final bool easing = (overScrollPastStart > 0.0 && offset < 0.0) || (overScrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        ? frictionFactor((overScrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overScrollPast / position.viewportDimension);

    final double direction = offset.sign;

    return direction * _applyFriction(overScrollPast, offset.abs(), friction);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) => 0.0;

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.91,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double get minFlingDistance => 50.0 * 2;

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign * min(0.000816 * pow(existingVelocity.abs(), 1.967).toDouble(), 40000.0);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}
