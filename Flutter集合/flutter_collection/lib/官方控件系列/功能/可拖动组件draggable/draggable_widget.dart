import 'package:english_words/english_words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// [Draggable]能够让您的小部件被用户拖拽
/// 并能获取拖拽的位置信息
/// [Positioned]能够对根据偏移量[offset]进行定位
/// 而[Draggable]的[child]是它被拖动前的样子
/// [feedback]是它被拖动时的样子，这里在颜色上加了[opacity]进行了区分
/// 而[data]是他在拖动到[DragTarget]将会传递的参数
/// 在[DragTarget]中，可以通过[onAccept]获取这个[data]
///
/// 这里在拖拽结束时会调用[onDraggableCanceled]，
/// 并传入被拖拽后的偏移量[offset]
/// 我们刷新这个[offset]就改变了[Positioned]的位置
class DraggableWidget extends StatefulWidget {
  /// 偏移量
  final Offset offset;

  /// 组件颜色
  final Color widgetColor;

  const DraggableWidget({Key key, this.offset, this.widgetColor}) : super(key: key);

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _offset = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Draggable(
        data: widget.widgetColor,
        child: Container(
          width: 100.0,
          height: 100.0,
          color: widget.widgetColor,
        ),
        feedback: Container(
          width: 100.0,
          height: 100.0,
          color: widget.widgetColor.withOpacity(0.5),
        ),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          setState(() {
            _offset = offset;
          });
        },
      ),
    );
  }
}
