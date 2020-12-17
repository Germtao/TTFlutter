import 'package:flutter/material.dart';
import 'expand_able_controller.dart';

class ExpandableInheritedNotifier extends InheritedNotifier<ExpandableController> {
  ExpandableInheritedNotifier({
    @required ExpandableController controller,
    @required Widget child,
  }) : super(notifier: controller, child: child);
}
