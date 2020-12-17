import 'package:flutter/material.dart';
import 'expand_able_controller.dart';

/// 通过滚动外部视口来确保 child 在屏幕上可见
/// 当外部 [ExpandableNotifier] 传递更改事件时
///
/// 也可以看看:
///
/// [RenderObject.showOnScreen]
class ScrollOnExpand extends StatefulWidget {
  final Widget child;

  final Duration scrollAnimationDuration;

  /// 如果为true，则小部件将滚动以展开时可见
  final bool scrollOnExpand;

  /// 如果为true，则小部件将滚动以使其折叠时可见
  final bool scrollOnCollaps;

  ScrollOnExpand({
    Key key,
    @required this.child,
    this.scrollAnimationDuration = const Duration(milliseconds: 300),
    this.scrollOnExpand = true,
    this.scrollOnCollaps = true,
  }) : super(key: key);

  @override
  _ScrollOnExpandState createState() => _ScrollOnExpandState();
}

class _ScrollOnExpandState extends State<ScrollOnExpand> {
  ExpandableController _controller;
  int _isAnimating = 0;
  BuildContext _lastContext;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController.of(context, rebuildOnChange: false);
    _controller.addListener(_expandedStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_expandedStateChanged);
  }

  @override
  void didUpdateWidget(ScrollOnExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController = ExpandableController.of(context, rebuildOnChange: false);
    if (newController != _controller) {
      _controller.removeListener(_expandedStateChanged);
      _controller = newController;
      _controller.addListener(_expandedStateChanged);
    }
  }

  _animationComplete() {
    _isAnimating--;
    if (_isAnimating == 0 && _lastContext != null && mounted) {
      if ((_controller.expanded && widget.scrollOnExpand) || (!_controller.expanded && widget.scrollOnCollaps)) {
        _lastContext?.findRenderObject()?.showOnScreen(duration: widget.scrollAnimationDuration);
      }
    }
  }

  _expandedStateChanged() {
    _isAnimating++;
    Future.delayed(
      _controller.animationDuration + Duration(milliseconds: 10),
      _animationComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    _lastContext = context;
    return widget.child;
  }
}
