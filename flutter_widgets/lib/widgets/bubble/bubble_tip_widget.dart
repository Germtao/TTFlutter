import 'package:flutter/material.dart';

import 'bubble_painter.dart';

/// 气泡提示弹窗
class BubbleTipWidget extends StatefulWidget {
  /// 弹窗高度
  final double height;

  /// 弹窗宽度
  final double width;

  /// 弹窗圆角
  final double radius;

  /// 弹窗文本
  final String text;

  /// 三角形指向的 x 坐标
  final double x;

  /// 三角形指向的 y 坐标
  final double y;

  /// 三角形位置
  final ArrowLocation arrowLocation;

  final VoidCallback callback;

  const BubbleTipWidget({
    this.width,
    this.height,
    this.radius,
    this.text = "",
    this.x = 0,
    this.y = 0,
    this.arrowLocation = ArrowLocation.Bottom,
    this.callback,
  });

  @override
  _BubbleTipWidgetState createState() => _BubbleTipWidgetState();
}

class _BubbleTipWidgetState extends State<BubbleTipWidget> with SingleTickerProviderStateMixin {
  AnimationController progressController;

  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double arrowWidth = 10;
    double arrowHeight = 10;

    double x = widget.x;
    double y = widget.y;
    Size size = MediaQuery.of(context).size;

    // 计算位置的中心点
    if (widget.arrowLocation == ArrowLocation.Bottom || widget.arrowLocation == ArrowLocation.Top) {
      x = widget.x - widget.width / 2;
    } else {
      y = widget.y - widget.height / 2;
    }

    // 宽度是否超出
    bool widthOut = (widget.width + x) > size.width || x < 0;

    // 高度是否超出
    bool heightOut = (widget.height + y) > size.height || y < 0;

    if (x < 0) {
      x = 0;
    } else if (widthOut) {
      x = size.width - widget.width;
    }

    if (y < 0) {
      y = 0;
    } else if (heightOut) {
      y = size.height - widget.height;
    }

    // 箭头在这个状态下是否需要居中
    bool arrowCenter = (widget.arrowLocation == ArrowLocation.Bottom || widget.arrowLocation == ArrowLocation.Top)
        ? !widthOut
        : !heightOut;

    // 调整箭头状态，因为此时箭头会可能不是局中的
    double arrowPosition = (widget.arrowLocation == ArrowLocation.Bottom || widget.arrowLocation == ArrowLocation.Top)
        ? (widget.x - x - arrowWidth / 2)
        : (widget.y - y - arrowHeight / 2);

    // 箭头的位置是按照弹出框的左边为起点计算的
    if (widget.arrowLocation == ArrowLocation.Bottom || widget.arrowLocation == ArrowLocation.Top) {
      if (arrowPosition < widget.radius + 2) {
        arrowPosition = widget.radius + 4;
      } else if (arrowPosition > widget.width - widget.radius - 2) {
        arrowPosition = widget.width - widget.radius - 4;
      }
    } else {
      if (arrowPosition < widget.radius + 2) {
        arrowPosition = widget.radius + 4;
      } else if (x > widget.height - widget.radius - 2) {
        arrowPosition = widget.width - widget.radius - 4;
      }
    }

    EdgeInsets margin = EdgeInsets.zero;
    if (widget.arrowLocation == ArrowLocation.Top) {
      margin = EdgeInsets.only(top: arrowHeight, right: 5, left: 5);
    }

    var bubbleBuilder = BubbleBuilder();
    bubbleBuilder.mAngle = widget.radius;
    bubbleBuilder.mArrowWidth = arrowWidth;
    bubbleBuilder.mArrowHeight = arrowHeight;
    bubbleBuilder.mArrowLocation = widget.arrowLocation;
    bubbleBuilder.mArrowPosition = arrowPosition;
    bubbleBuilder.arrowCenter = arrowCenter;

    var alignment = Alignment.centerLeft;
    if (widget.arrowLocation == ArrowLocation.Top || widget.arrowLocation == ArrowLocation.Bottom) {
      alignment = Alignment.center;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Container(
          alignment: Alignment.centerLeft,
          width: widget.width,
          height: widget.height,
          margin: EdgeInsets.only(left: x, top: y),
          child: Stack(
            children: [
              // 绘制气泡背景
              CustomPaint(
                key: paintKey,
                size: Size(widget.width, widget.height),
                painter: bubbleBuilder.build(),
              ),

              Align(
                alignment: alignment,

                // 显示文本
                child: Container(
                  margin: margin,
                  width: widget.width,
                  height: widget.height - arrowHeight,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        height: widget.height,
                        child: Icon(
                          Icons.notifications,
                          size: widget.height - 30,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            widget.text,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {}
  void _onPanUpdate(DragUpdateDetails details) {}
  void _onPanEnd(DragEndDetails details) {
    widget.callback?.call();
  }
}
