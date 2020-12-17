import 'package:flutter/rendering.dart';

class CloudRenderParentData extends ContainerBoxParentData<RenderBox> {
  double width;
  double height;

  Rect get content => Rect.fromLTWH(
        offset.dx,
        offset.dy,
        width,
        height,
      );
}
