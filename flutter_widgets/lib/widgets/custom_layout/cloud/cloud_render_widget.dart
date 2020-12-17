import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './cloud_render_parent_data.dart';
import 'dart:math' as Math;

/// CloudWidget RenderBox
/// 默认都会 mixins  ContainerRenderObjectMixin 和 RenderBoxContainerDefaultsMixin
class CloudRenderWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CloudRenderParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CloudRenderParentData> {
  CloudRenderWidget({
    List<RenderBox> children,
    Overflow overflow = Overflow.visible,
    double ratio,
  })  : _ratio = ratio,
        _overflow = overflow {
    addAll(children);
  }

  /// 圆周
  double _mathPi = Math.pi * 2;

  /// 是否需要裁剪
  bool _needClip = false;

  /// 溢出
  Overflow _overflow;
  Overflow get overflow => _overflow;
  set overflow(Overflow value) {
    assert(value != null);
    if (_overflow != value) {
      _overflow = value;
      markNeedsPaint();
    }
  }

  /// 比例
  double _ratio;
  double get ratio => _ratio;
  set ratio(double value) {
    assert(value != null);
    if (_ratio != value) {
      _ratio = value;
      markNeedsPaint();
    }
  }

  /// 是否重复区域了
  bool overlays(CloudRenderParentData data) {
    Rect rect = data.content;

    RenderBox child = data.previousSibling;

    if (child == null) {
      return false;
    }

    do {
      CloudRenderParentData childParentData = child.parentData;
      if (rect.overlaps(childParentData.content)) {
        return true;
      }
      child = childParentData.previousSibling;
    } while (child != null);

    return false;
  }

  /// 设置为我们的数据
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CloudRenderParentData) {
      child.parentData = CloudRenderParentData();
    }
  }

  @override
  void performLayout() {
    // 默认不需要裁剪
    _needClip = false;

    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    // 初始化区域
    var recordRect = Rect.zero;
    var previousChildRect = Rect.zero;

    RenderBox child = firstChild;

    while (child != null) {
      var currentIndex = -1;

      // 提取数据
      final CloudRenderParentData childParentData = child.parentData;

      child.layout(constraints, parentUsesSize: true);

      var childSize = child.size;

      // 记录大小
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      do {
        // 设置 x/y 轴比例
        var ratioX = ratio >= 1 ? ratio : 1.0;
        var ratioY = ratio <= 1 ? ratio : 1.0;

        // 调整位置
        var step = _mathPi * 0.02;
        var rotation = 0.0;
        var angle = currentIndex * step;
        var angleRadius = 5 + 5 * angle;
        var x = ratioX * angleRadius * Math.cos(angle + rotation);
        var y = ratioY * angleRadius * Math.sin(angle + rotation);
        var position = Offset(x, y);

        // 计算得到绝对偏移
        var childOffset = position - Alignment.center.alongSize(childSize);

        ++currentIndex;

        // 设置为 遏制
        childParentData.offset = childOffset;

        // 判断是否交叠
      } while (overlays(childParentData));

      // 记录区域
      previousChildRect = childParentData.content;
      recordRect = recordRect.expandToInclude(previousChildRect);

      // 下一个
      child = childParentData.nextSibling;
    }

    // 调整布局大小
    size = constraints
        .tighten(
          width: recordRect.width,
          height: recordRect.height,
        )
        .smallest;

    // 居中
    var contentCenter = size.center(Offset.zero);
    var recordRectCenter = recordRect.center;
    var transCenter = contentCenter - recordRectCenter;
    child = firstChild;
    while (child != null) {
      final CloudRenderParentData childParentData = child.parentData;
      childParentData.offset += transCenter;
      child = childParentData.nextSibling;
    }

    // 超过了吗？
    _needClip = size.width < recordRect.width || size.height < recordRect.height;
  }

  /// 设置默认绘制
  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_needClip || _overflow != Overflow.clip) {
      defaultPaint(context, offset);
    } else {
      context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        defaultPaint,
      );
    }
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
