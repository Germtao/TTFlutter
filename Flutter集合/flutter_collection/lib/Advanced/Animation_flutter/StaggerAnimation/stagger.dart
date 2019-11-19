import 'package:flutter/material.dart';

class StaggerAnimation extends StatefulWidget {
  StaggerAnimation({Key key, this.controller}) : super(key: key);

  final Animation<double> controller;

  @override
  _StaggerAnimationState createState() => _StaggerAnimationState();
}

class _StaggerAnimationState extends State<StaggerAnimation> {
  Animation<double> _height;
  Animation<EdgeInsets> _padding;
  Animation<Color> _color;

  @override
  void initState() {
    super.initState();
    // 高度动画
    _height = Tween<double>(
      begin: .0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.0, 0.6, curve: Curves.ease), // 间隔，前60%的动画时间
      ),
    );

    // 颜色动画
    _color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.0, 0.6, curve: Curves.ease), // 间隔，前60%的动画时间
      ),
    );

    // 平移动画
    _padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: .0),
      end: EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.6, 1.0, curve: Curves.ease), // 间隔，后40%的动画时间
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: _padding.value,
      child: Container(
        color: _color.value,
        width: 50.0,
        height: _height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.controller,
    );
  }
}
