import 'package:flutter/material.dart';

class ChipPage extends StatefulWidget {
  final String type;

  ChipPage({Key key, this.type}) : super(key: key);

  @override
  _ChipPageState createState() => _ChipPageState();
}

class _ChipPageState extends State<ChipPage> with AutomaticKeepAliveClientMixin {
  String _type;

  /// 描述
  String _description;

  bool _isFiltered = false;
  bool _isChoiced = false;
  bool _isInputed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _type = widget.type;

    switch (_type) {
      case 'Default':
        _description = '普通Chip, 可以自定义样式';
        break;
      case 'Action':
        _description = '主要是在chip的基础上提供了一个onPress方法, 能够触发一些动作';
        break;
      case 'Filter':
        _description = '被选中时会出来一个勾勾';
        break;
      case 'Choice':
        _description = '类似Fliter, 没有勾勾';
        break;
      case 'Input':
        _description = 'Input Chip';
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWidget(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Text(
              '$_description',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget buildWidget() {
    switch (_type) {
      case 'Default': //
        return Chip(
          label: Text('Chip'),
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: Text('01'),
          ),
          onDeleted: () {},
        );
      case 'Action':
        return ActionChip(
          label: Text('Action'),
          onPressed: () {
            setState(() {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('ON TAP'),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            });
          },
        );
      case 'Filter':
        return FilterChip(
          label: Text('Filter'),
          selected: _isFiltered,
          onSelected: (isSelected) {
            setState(() => _isFiltered = isSelected);
          },
          selectedColor: Colors.blue.shade400,
        );
      case 'Choice':
        return ChoiceChip(
          label: Text('Choice'),
          selected: _isChoiced,
          onSelected: (isSelected) {
            setState(() {
              _isChoiced = isSelected;
            });
          },
          selectedColor: Colors.blue.shade400,
        );
      case 'Input':
        return InputChip(
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: Text('AB'),
          ),
          label: Text('Input'),
          onPressed: () {
            setState(() {
              _isInputed = !_isInputed;
              _description = _isInputed ? '已经点击了' : 'Input';
            });
          },
          onDeleted: () {},
        );
      default:
        return null;
    }
  }
}
