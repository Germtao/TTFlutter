import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as Math;

class ViewPagerTransformer extends PageTransformer {
  final TransformerType transformerType;

  final double scale;
  final double fade;

  ViewPagerTransformer(this.transformerType, {this.scale = 0.8, this.fade = 0.3})
      : super(reverse: transformerType == TransformerType.Deepth);

  @override
  Widget transform(Widget child, TransformInfo info) {
    switch (transformerType) {
      case TransformerType.Accordion:
        return _buildAccordion(child, info);
        break;
      case TransformerType.ThreeD:
        return _buildThreeD(child, info);
      case TransformerType.ZoomIn:
        return _buildZoomIn(child, info);
      case TransformerType.ZoomOut:
        return _buildZoomOut(child, info);
      case TransformerType.Deepth:
        return _buildDeepth(child, info);
      case TransformerType.ScaleAndFade:
        return _buildScaleAndFade(child, info);
    }
  }

  _buildAccordion(Widget child, TransformInfo info) {
    double position = info.position;
    if (position < 0.0) {
      return Transform.scale(
        scale: 1 + position,
        alignment: Alignment.topRight,
        child: child,
      );
    } else {
      return Transform.scale(
        scale: 1 - position,
        alignment: Alignment.bottomLeft,
        child: child,
      );
    }
  }

  _buildThreeD(Widget child, TransformInfo info) {
    double position = info.position;
    double width = info.width;
    double height = info.height;
    double pivotX = 0.0;
    if (position < 0 && position >= -1) {
      // left scrolling
      pivotX = width;
    }

    return Transform(
      transform: Matrix4.identity()..rotate(vector.Vector3(0.0, 2.0, 0.0), position * 1.5),
      origin: Offset(pivotX, height / 2),
      child: child,
    );
  }

  _buildZoomIn(Widget child, TransformInfo info) {
    double position = info.position;
    double width = info.width;
    if (position > 0 && position <= 1) {
      return Transform.translate(
        offset: Offset(-width * position, 0.0),
        child: Transform.scale(
          scale: 1 - position,
          child: child,
        ),
      );
    }
    return child;
  }

  static const double MIN_SCALE = 0.85;
  static const double MIN_ALPHA = 0.5;
  _buildZoomOut(Widget child, TransformInfo info) {
    double position = info.position;
    double pageWidth = info.width;
    double pageHeight = info.height;

    if (position < -1) {
      // [-Infinity,-1)
      // 该页面在屏幕外的左侧
      // view.setAlpha(0);
    } else if (position <= 1) {
      // [-1, 1]
      // 将默认幻灯片过渡修改为 缩小页面
      double scaleFactor = Math.max(MIN_SCALE, 1 - position.abs());
      double vertMargin = pageHeight * (1 - scaleFactor) / 2;
      double horzMargin = pageWidth * (1 - scaleFactor) / 2;
      double dx;
      if (position < 0) {
        dx = (horzMargin - vertMargin / 2);
      } else {
        dx = (-horzMargin + vertMargin / 2);
      }
      // 缩小页面（在MIN_SCALE和1之间）
      double opacity = MIN_ALPHA + (scaleFactor - MIN_SCALE) / (1 - MIN_SCALE) * (1 - MIN_ALPHA);

      return Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(dx, 0.0),
          child: Transform.scale(
            scale: scaleFactor,
            child: child,
          ),
        ),
      );
    } else {
      // (1, +Infinity]
      // 该页面在屏幕外的右侧
      // view.setAlpha(0);
    }
  }

  _buildDeepth(Widget child, TransformInfo info) {
    double position = info.position;
    if (position <= 0) {
      return Opacity(
        opacity: 1.0,
        child: Transform.translate(
          offset: Offset.zero,
          child: Transform.scale(
            scale: 1.0,
            child: child,
          ),
        ),
      );
    } else if (position <= 1) {
      const double MIN_SCALE = 0.75;
      // 缩小页面（在MIN_SCALE和1之间）
      double scaleFactor = MIN_SCALE + (1 - MIN_SCALE) * (1 - position);

      return Opacity(
        opacity: 1 - position,
        child: Transform.translate(
          offset: Offset(info.width * -position, 0.0),
          child: Transform.scale(
            scale: scaleFactor,
            child: child,
          ),
        ),
      );
    }
    return child;
  }

  _buildScaleAndFade(Widget child, TransformInfo info) {
    double position = info.position;
    double scaleFactor = (1 - position.abs()) * (1 - this.scale);
    double fadeFactor = (1 - position.abs()) * (1 - this.fade);
    double opacity = this.fade + fadeFactor;
    double scale = this.scale + scaleFactor;
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: child,
      ),
    );
  }
}

enum TransformerType {
  Accordion,
  ThreeD,
  ZoomIn,
  ZoomOut,
  Deepth,
  ScaleAndFade,
}
