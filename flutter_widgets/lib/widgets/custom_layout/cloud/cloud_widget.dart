import 'package:flutter/material.dart';
import './cloud_render_widget.dart';

class CloudWidget extends MultiChildRenderObjectWidget {
  final Overflow overflow;
  final double ratio;

  CloudWidget({
    Key key,
    this.ratio = 1.0,
    this.overflow = Overflow.clip,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CloudRenderWidget(
      ratio: ratio,
      overflow: overflow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, CloudRenderWidget renderObject) {
    renderObject
      ..ratio = ratio
      ..overflow = overflow;
  }
}
