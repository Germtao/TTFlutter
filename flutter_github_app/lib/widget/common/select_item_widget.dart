import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';

typedef void SelectItemChanged<int>(int value);

/// 详情 issue 列表头部
class SelectItemWidget extends StatefulWidget implements PreferredSizeWidget {
  final List<String> itemNames;

  final SelectItemChanged selectItemChanged;

  final RoundedRectangleBorder shape;

  final double elevation;

  final double height;

  final EdgeInsets margin;

  SelectItemWidget(
    this.itemNames,
    this.selectItemChanged, {
    this.elevation = 5.0,
    this.height = 70.0,
    this.shape,
    this.margin = const EdgeInsets.all(10.0),
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  _SelectItemWidgetState createState() => _SelectItemWidgetState();
}

class _SelectItemWidgetState extends State<SelectItemWidget> {
  int selectIndex = 0;

  _SelectItemWidgetState();

  _renderItem(String name, int index) {
    var style = index == selectIndex ? TTConstant.middleTextWhite : TTConstant.middleSubLightText;
    return Expanded(
      child: AnimatedSwitcher(
        transitionBuilder: (child, anim) {
          return ScaleTransition(
            child: child,
            scale: anim,
          );
        },
        duration: Duration(milliseconds: 300),
        child: RawMaterialButton(
          key: ValueKey(index == selectIndex),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            name,
            style: style,
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            if (selectIndex != index) {
              widget.selectItemChanged?.call(index);
            }
            setState(() {
              selectIndex = index;
            });
          },
        ),
      ),
    );
  }

  _renderList() {
    List<Widget> list = List();
    for (int i = 0; i < widget.itemNames.length; i++) {
      if (i == widget.itemNames.length - 1) {
        list.add(_renderItem(widget.itemNames[i], i));
      } else {
        list.add(_renderItem(widget.itemNames[i], i));
        list.add(Container(
          width: 1.0,
          height: 25.0,
          color: TTColors.subLightTextColor,
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return TTCardItem(
      elevation: widget.elevation,
      margin: widget.margin,
      color: Theme.of(context).primaryColor,
      shape: widget.shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          )),
      child: Row(
        children: _renderList(),
      ),
    );
  }
}
