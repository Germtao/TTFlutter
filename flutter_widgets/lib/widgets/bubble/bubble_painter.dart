import 'package:flutter/material.dart';
import 'dart:math' as Math;

/// 绘制气泡背景
class BubblePainter extends CustomPainter {
  Rect mRect;
  Path mPath = Path();
  Paint mPaint = Paint();
  double mArrowWidth;
  double mAngle;
  double mArrowHeight;
  double mArrowPosition;
  ArrowLocation mArrowLocation;
  BubbleType bubbleType;
  bool mArrowCenter = true;
  Color bubbleColor;

  BubblePainter(BubbleBuilder builder) {
    this.mAngle = builder.mAngle;
    this.mArrowWidth = builder.mArrowWidth;
    this.mArrowHeight = builder.mArrowHeight;
    this.mArrowPosition = builder.mArrowPosition;
    this.mArrowLocation = builder.mArrowLocation;
    this.bubbleColor = builder.bubbleColor;
    this.bubbleType = builder.bubbleType;
    this.mArrowCenter = builder.arrowCenter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    setup(canvas, size);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BubblePainter oldDelegate) => false;

  /// 左：绘制三角形
  void drawLeftPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.bottom - rect.top) / 2 - mArrowWidth / 2;
    }

    path.moveTo(rect.left + mArrowWidth, mArrowHeight + mArrowPosition);
    path.lineTo(rect.left + mArrowWidth, mArrowHeight + mArrowPosition);
    path.lineTo(rect.left, mArrowPosition + mArrowHeight / 2);
    path.lineTo(rect.left + mArrowWidth, mArrowPosition);
    path.lineTo(rect.left + mArrowWidth, rect.top + mAngle);

    path.addRRect(RRect.fromLTRBR(
      rect.left + mArrowHeight,
      rect.top,
      rect.right,
      rect.bottom,
      Radius.circular(mAngle),
    ));

    path.close();
  }

  /// 右：绘制三角形
  void drawRightPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.bottom - rect.top) / 2 - mArrowWidth / 2;
    }

    path.moveTo(rect.right - mArrowWidth, mArrowPosition);

    path.lineTo(rect.right - mArrowWidth, mArrowPosition);
    path.lineTo(rect.right, mArrowPosition + mArrowHeight / 2);
    path.lineTo(rect.right - mArrowWidth, mArrowPosition + mArrowHeight);

    path.moveTo(rect.left + mAngle, rect.top);

    path.addRRect(RRect.fromLTRBR(
      rect.left,
      rect.top,
      rect.right - mArrowHeight,
      rect.bottom,
      Radius.circular(mAngle),
    ));

    path.close();
  }

  /// 上：绘制三角形
  void drawTopPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.right - rect.left) / 2 - mArrowWidth / 2;
    }

    path.moveTo(rect.left + Math.min(mArrowPosition, mAngle), rect.top + mArrowHeight);
    path.lineTo(rect.left + mArrowPosition, rect.top + mArrowHeight);
    path.lineTo(rect.left + mArrowWidth / 2 + mArrowPosition, rect.top);
    path.lineTo(rect.left + mArrowWidth + mArrowPosition, rect.top + mArrowHeight);

    path.addRRect(RRect.fromLTRBR(
      rect.left,
      rect.top + mArrowHeight,
      rect.right,
      rect.bottom,
      Radius.circular(mAngle),
    ));

    path.close();
  }

  /// 底：绘制三角形
  void drawBottomPath(Rect rect, Path path) {
    if (mArrowCenter) {
      mArrowPosition = (rect.right - rect.left) / 2 - mArrowWidth / 2;
    }

    path.moveTo(rect.left + mArrowWidth + mArrowPosition, rect.bottom - mArrowHeight);

    path.lineTo(rect.left + mArrowWidth + mArrowPosition, rect.bottom - mArrowHeight);
    path.lineTo(rect.left + mArrowPosition + mArrowWidth / 2, rect.bottom);
    path.lineTo(rect.left + mArrowPosition, rect.bottom - mArrowHeight);

    path.addRRect(RRect.fromLTRBR(
      rect.left,
      rect.top,
      rect.right,
      rect.bottom - mArrowHeight,
      Radius.circular(mAngle),
    ));

    path.close();
  }

  /// 设置绘制路径
  void setupPath(ArrowLocation mArrowLocation, Path path) {
    switch (mArrowLocation) {
      case ArrowLocation.Left:
        drawLeftPath(mRect, path);
        break;
      case ArrowLocation.Right:
        drawRightPath(mRect, path);
        break;
      case ArrowLocation.Top:
        drawTopPath(mRect, path);
        break;
      case ArrowLocation.Bottom:
        drawBottomPath(mRect, path);
        break;
    }
  }

  /// 开始绘制设置
  void setup(Canvas canvas, Size size) {
    switch (bubbleType) {
      case BubbleType.Color:
        mPaint.color = bubbleColor;
        break;
      default:
        break;
    }

    mRect ??= Rect.fromLTRB(0, 0, size.width, size.height);
    setupPath(mArrowLocation, mPath);
    canvas.drawPath(mPath, mPaint);
  }
}

class BubbleBuilder {
  static const double DEFAULT_ARROW_WIDTH = 15;
  static const double DEFAULT_ARROW_HEIGHT = 15;
  static const double DEFAULT_ARROW_ANGLE = 20;
  static const double DEFAULT_ARROW_POSITION = 50;
  static const Color DEFAULT_ARROW_BUBBLE_COLOR = Colors.white;

  /// 圆角
  double mAngle = DEFAULT_ARROW_ANGLE;

  /// 箭头宽度
  double mArrowWidth = DEFAULT_ARROW_WIDTH;

  /// 箭头高度
  double mArrowHeight = DEFAULT_ARROW_HEIGHT;

  /// 箭头位置
  double mArrowPosition = DEFAULT_ARROW_POSITION;

  /// 背景色
  Color bubbleColor = DEFAULT_ARROW_BUBBLE_COLOR;

  /// 背景类型: 颜色
  BubbleType bubbleType = BubbleType.Color;

  /// 箭头位置
  ArrowLocation mArrowLocation = ArrowLocation.Bottom;

  /// 箭头是否居中
  bool arrowCenter = true;

  build() {
    return BubblePainter(this);
  }
}

enum ArrowLocation { Left, Right, Top, Bottom }

enum BubbleType { Color, Bitmap }
