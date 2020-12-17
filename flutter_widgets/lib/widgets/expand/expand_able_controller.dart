import 'package:flutter/material.dart';
import 'expand_able_inherited_notifier.dart';

class ExpandableController extends ValueNotifier<bool> {
  bool get expanded => value;

  final Duration animationDuration;

  ExpandableController({bool initialExpanded, Duration animationDuration})
      : this.animationDuration = animationDuration ?? const Duration(milliseconds: 300),
        super(initialExpanded ?? false);

  set expanded(bool expanded) {
    value = expanded;
  }

  void toggle() {
    expanded = !expanded;
  }

  static ExpandableController of(BuildContext context, {bool rebuildOnChange = true}) {
    final notifier = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<ExpandableInheritedNotifier>()
        : context.findAncestorWidgetOfExactType<ExpandableInheritedNotifier>();

    return notifier?.notifier;
  }
}
