import 'package:flutter/material.dart';

/// 控制列表展开、关闭状态的类
class ExpandState {
  var isExpand; // 是否打开
  var index; // 下标

  ExpandState(this.index, this.isExpand);
}

///  说实话，我觉得expansion panel list一点都不好用
///  所以不想写注释。
///  这里样例代码来自于flutter开发者
///  他会经常更新一些flutter教程，写的挺不错的，有兴趣自己去看看吧
///  https://mp.weixin.qq.com/s/Qv08V42LgEr8IATUSfVVHg
///
///  需要注意几点：
///  ExpansionPanelList必须放在可滑动组件中使用
///  ExpansionPanel只能在ExpansionPanelList中使用
///  除了ExpansionPanel还有一种特殊的ExpansionPanelRadio
///  也是只能在ExpansionPanelList中使用的
class ExpansionPanelListWidget extends StatefulWidget {
  @override
  _ExpansionPanelListWidgetState createState() => _ExpansionPanelListWidgetState();
}

class _ExpansionPanelListWidgetState extends State<ExpansionPanelListWidget> {
  List<int> _indexList; // 多少个元素
  List<ExpandState> _expandStateList;

  // 内部使用的构造方法, 初始化数据
  _ExpansionPanelListWidgetState() {
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
        title: Text('Expansion Panel List'),
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
