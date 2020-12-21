import 'package:flutter/material.dart';

/// title bar widget
class TitleBar extends StatelessWidget {
  final String title;
  final IconData iconData;
  final ValueChanged onRightIconPressed;
  final bool needRightLocalIcon;
  final Widget rightWidget;
  final GlobalKey rightKey = GlobalKey();

  TitleBar(
    this.title, {
    this.iconData,
    this.onRightIconPressed,
    this.needRightLocalIcon = false,
    this.rightWidget,
  });

  _iconButton() {
    return IconButton(
      icon: Icon(
        iconData,
        key: rightKey,
        size: 19.0,
      ),
      onPressed: () {
        RenderBox renderBox = rightKey.currentContext?.findRenderObject();
        var position = renderBox.localToGlobal(Offset.zero);
        var size = renderBox.size;
        var centerPosition = Offset(
          position.dx + size.width / 2,
          position.dy + size.height / 2,
        );
        onRightIconPressed?.call(centerPosition);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _rightWidget = rightWidget;
    if (rightWidget == null) {
      _rightWidget = needRightLocalIcon ? _iconButton() : Container();
    }
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _rightWidget,
        ],
      ),
    );
  }
}
