import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as Math;

class StickRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, StickParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StickParentData> {
  ScrollableState _scrollableState;

  StickRender({@required ScrollableState scrollableState}) {
    _scrollableState = scrollableState;
  }

  set scrollableState(ScrollableState scrollableState) {
    if (_scrollableState == scrollableState) {
      return;
    }

    final ScrollableState preScrollableState = _scrollableState;
    _scrollableState = scrollableState;

    if (attached) {
      // 触发更新
      preScrollableState.position?.removeListener(markNeedsLayout);
      scrollableState.position?.addListener(markNeedsLayout);
    }

    markNeedsLayout();
  }

  double getScrollAbleDy() {
    RenderObject renderObject = _scrollableState.context.findRenderObject();
    if (!renderObject.attached) {
      return 0;
    }

    try {
      return localToGlobal(Offset.zero, ancestor: renderObject).dy;
    } catch (e) {
      print('getScrollAbleDy error: $e');
    }

    return 0;
  }

  @override
  void attach(PipelineOwner owner) {
    // 设置监听
    _scrollableState.position?.addListener(markNeedsLayout);
    super.attach(owner);
  }

  @override
  void detach() {
    // 移除监听
    _scrollableState.position.removeListener(markNeedsLayout);
    super.detach();
  }

  // 设置为 isRepaintBoundary 或者性能会好一些。
  // @override
  // bool get isRepaintBoundary => true;

  @override
  double computeMinIntrinsicHeight(double width) {
    return (lastChild.getMinIntrinsicHeight(width) + firstChild.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return (lastChild.getMaxIntrinsicHeight(width) + firstChild.getMaxIntrinsicHeight(width));
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  // 设置默认绘制
  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  // 设置我们的 StickParentData
  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! StickParentData) {
      child.parentData = StickParentData();
    }
  }

  @override
  void performLayout() {
    var header = lastChild;
    var content = firstChild;

    // 取消最小宽度
    var loosenConstraints = constraints.loosen();
    content.layout(loosenConstraints, parentUsesSize: true);
    header.layout(loosenConstraints, parentUsesSize: true);

    // 获取各自的高度用户计算
    var contentHeight = content.size.height;
    var headerHeight = header.size.height;

    // 对于当前布局, 用内容作为宽度
    var width = content.size.width;
    var height = header.size.height + contentHeight;
    size = Size(width, height);

    // 内容的初始化位置
    (content.parentData as StickParentData).offset = Offset(0, headerHeight);

    // 计算出 header 需要的整体偏移量，用于反方向
    var headerOffset = height - headerHeight;

    // 判断当前 item 在 ScrollAble 中的偏移
    var scrollAbleDy = getScrollAbleDy();

    // 真实的头部滑动偏移量
    var realHeaderOffset = Math.min(-scrollAbleDy, headerOffset);
    (header.parentData as StickParentData).offset = Offset(0, Math.max(0, realHeaderOffset));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class StickParentData extends ContainerBoxParentData<RenderBox> {}
