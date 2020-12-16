import 'package:flutter/material.dart';
import 'stick_render.dart';

class StickWidget extends MultiChildRenderObjectWidget {
  /// 顺序添加 stickHeader 和 stickContent
  StickWidget({
    @required stickHeader,
    @required stickContent,
  }) : super(
          // 如果反过来，会有意想不到的效果
          children: [stickContent, stickHeader],
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    // 传入 ScrollableState
    return StickRender(scrollableState: Scrollable.of(context));
  }

  @override
  void updateRenderObject(BuildContext context, StickRender renderObject) {
    renderObject..scrollableState = Scrollable.of(context);
  }
}
