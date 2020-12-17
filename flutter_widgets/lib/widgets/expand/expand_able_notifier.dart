import 'package:flutter/material.dart';
import 'expand_able_controller.dart';
import 'expand_able_inherited_notifier.dart';

class ExpandableNotifier extends StatefulWidget {
  final ExpandableController controller;
  final bool initialExpanded;
  final Duration animationDuration;
  final Widget child;

  ExpandableNotifier({
    Key key,
    this.controller,
    this.initialExpanded,
    this.animationDuration,
    @required this.child,
  })  : assert(!(controller != null && animationDuration != null)),
        assert(!(controller != null && initialExpanded != null)),
        super(key: key);

  @override
  _ExpandableNotifierState createState() => _ExpandableNotifierState();
}

class _ExpandableNotifierState extends State<ExpandableNotifier> {
  ExpandableController controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = ExpandableController(
        initialExpanded: widget.initialExpanded ?? false,
        animationDuration: widget.animationDuration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableInheritedNotifier(
      controller: controller ?? widget.controller,
      child: widget.child,
    );
  }
}
