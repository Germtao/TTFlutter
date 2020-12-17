import 'package:flutter/material.dart';
import 'expand_able_controller.dart';

/// 根据状态显示展开或折​​叠的子级
/// 状态由 [ScopedModel] 提供的 [ExpandableController] 实例确定
class Expandable extends StatelessWidget {
  /// 折叠时显示的小部件
  final Widget collapsed;

  /// 展开时显示的小部件
  final Widget expanded;

  final Duration animationDuration;
  final double collapsedFadeStart;
  final double collapsedFadeEnd;
  final double expandedFadeStart;
  final double expandedFadeEnd;
  final Curve fadeCurve;
  final Curve sizeCurve;

  Expandable({
    this.collapsed,
    this.expanded,
    this.collapsedFadeStart = 0,
    this.collapsedFadeEnd = 1,
    this.expandedFadeStart = 0,
    this.expandedFadeEnd = 1,
    this.fadeCurve = Curves.linear,
    this.sizeCurve = Curves.fastOutSlowIn,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    var controler = ExpandableController.of(context);

    return AnimatedCrossFade(
      firstChild: collapsed ?? Container(),
      secondChild: expanded ?? Container(),
      firstCurve: Interval(collapsedFadeStart, collapsedFadeEnd, curve: fadeCurve),
      secondCurve: Interval(expandedFadeStart, expandedFadeEnd, curve: fadeCurve),
      sizeCurve: sizeCurve,
      crossFadeState: controler.expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: animationDuration,
    );
  }
}

typedef Widget ExpandableBuilder(BuildContext context, Widget collapsed, Widget expanded);
