import 'package:flutter/material.dart';

// 控制列表展开、关闭状态的类
class ExpandState {
  var isExpand; // 是否打开
  var index; // 下标

  ExpandState(this.index, this.isExpand);
}

class ExpandsionPanelListWidget extends StatefulWidget {
  @override
  _ExpandsionPanelListWidgetState createState() =>
      _ExpandsionPanelListWidgetState();
}

class _ExpandsionPanelListWidgetState extends State<ExpandsionPanelListWidget> {
  List<int> _indexList; // 多少个元素
  List<ExpandState> _expandStateList;

  // 内部使用的构造方法, 初始化数据
  _ExpandsionPanelListWidgetState() {
    _indexList = List<int>();
    _expandStateList = List<ExpandState>();
    for (int i = 0; i < 10; i++) {
      _indexList.add(i);
      _expandStateList.add(ExpandState(i, false));
    }
  }

  _setCurrentTileState(int index, isExpand) {
    setState(() {
      _expandStateList.forEach((item) {
        if (item.index == index) {
          item.isExpand = !isExpand;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expandsion Panel List'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          children: _indexList.map((index) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text('This is NO.$index'),
                );
              },
              body: ListTile(
                title: Text('This is no.$index'),
              ),
              isExpanded: _expandStateList[index].isExpand,
            );
          }).toList(),
          expansionCallback: (index, isExpand) {
            _setCurrentTileState(index, isExpand);
          },
        ),
      ),
    );
  }
}
