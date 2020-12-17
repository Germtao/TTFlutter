import 'package:flutter/material.dart';
import 'stick_widget.dart';
import 'package:flutter_widgets/widgets/expand/index.dart';

import 'dart:math' as Math;

final random = Math.Random();
final stickHeader = 50.0;

/// 具备展开和收缩列表能力的Demo
class StickExpandDemoPage extends StatefulWidget {
  /// 随机生成 tagList 的 data List 数据
  final List<StickExpandModel> tagList = List.generate(
    50,
    (index) {
      return StickExpandModel(false, List(random.nextInt(20)));
    },
  );

  @override
  _StickExpandDemoPageState createState() => _StickExpandDemoPageState();
}

class _StickExpandDemoPageState extends State<StickExpandDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StickExpandDemoPage'),
      ),
      body: Container(
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: widget.tagList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.white,
              child: _buildStickWidget(index),
            );
          },
        ),
      ),
    );
  }

  _buildStickWidget(int index) {
    return StickWidget(
      // 头部停靠
      stickHeader: Container(
        height: stickHeader,
        color: Colors.deepPurpleAccent,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => print('stick header $index'),
          child: Text(
            'Header - $index',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      // 可展开内容
      stickContent: StickExpandChildList(widget.tagList[index]),
    );
  }
}

/// 可展开的内容列表
class StickExpandChildList extends StatefulWidget {
  final StickExpandModel expandModel;

  StickExpandChildList(this.expandModel);

  @override
  _StickExpandChildListState createState() => _StickExpandChildListState();
}

class _StickExpandChildListState extends State<StickExpandChildList> {
  // 用户获取 ExpandableVisibleContainer 的相对位置
  // 因为需要在收缩时回滚到这个类目的top位置
  final GlobalKey globalKey = GlobalKey();

  final int animMilliseconds = 300;

  /// 获取 globalKey 在 Scrollable 内的相对 y 滚动偏移量
  getY(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    double dy = renderBox
        .localToGlobal(
          Offset.zero,
          ancestor: Scrollable.of(context).context.findRenderObject(),
        )
        .dy;
    return dy;
  }

  /// 在收起时因为动画会有 stick 显示冲突
  /// 所以使用滚动和 notifyListeners 解决
  fixCloseState() {
    var y = getY(globalKey);
    Scrollable.of(context).position.jumpTo(Math.max(0, Scrollable.of(context).position.pixels + y) - stickHeader);
    widget.expandModel.expanded = false;

    /// 必须延时到收起动画结束后再更新 UI
    Future.delayed(
      Duration(milliseconds: animMilliseconds + 50),
      () {
        Scrollable.of(context).position.notifyListeners();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 150;
    double height = itemHeight * 30;
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: ExpandablePanel(
          height: height,
          initialExpanded: widget.expandModel.expanded,
          header: ExpandableVisibleContainer(
            widget.expandModel.dataList,
            visibleCount: 3,
            key: globalKey,
            expandedStateChanged: (_) {
              widget.expandModel.expanded = true;
            },
          ),
          builder: (context, collapsed, expanded) {
            return Expandable(
              animationDuration: Duration(milliseconds: animMilliseconds),
              collapsed: collapsed,
              expanded: expanded,
            );
          },
          expanded: ExpandableContainer(
            widget.expandModel.dataList,
            visibleCount: 3,
            expandedStateChanged: (_) {
              fixCloseState();
            },
          ),
          tapHeaderToExpand: false,
          hasIcon: false,
        ),
      ),
    );
  }
}

/// 默认可视区域
class ExpandableVisibleContainer extends StatelessWidget {
  final double itemHeight;
  final int visibleCount;
  final List dataList;
  final ExpandedStateChanged expandedStateChanged;

  ExpandableVisibleContainer(
    this.dataList, {
    @required this.visibleCount,
    this.itemHeight = 150,
    this.expandedStateChanged,
    key,
  }) : super(key: key);

  /// 大于可见数量才使用 查看更多
  renderExpandMore(context) {
    return Container(
      height: 50.0,
      color: Colors.grey,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          // 展开，回调
          ExpandableController.of(context).toggle();
          expandedStateChanged?.call(true);
        },
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Text(
            '查看更多',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 大于可见数量才使用 查看更多
    bool needExpanded = dataList.length > visibleCount;

    // 未展开时显示展开更多
    int realVisibleCount =
        ExpandableController.of(context).expanded ? visibleCount : (needExpanded ? visibleCount + 1 : visibleCount);

    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: List.generate(
            realVisibleCount,
            (index) {
              // 绘制加载更多按键
              if (index == visibleCount) {
                return renderExpandMore(context);
              }

              return InkWell(
                onTap: () => print('content $index'),
                child: Container(
                  color: Colors.pinkAccent,
                  height: itemHeight,
                  child: Center(
                    child: Text(
                      '我的 $index 内容!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 点击展开区域
class ExpandableContainer extends StatelessWidget {
  final double itemHeight;
  final ExpandedStateChanged expandedStateChanged;
  final List dataList;
  final int visibleCount;

  ExpandableContainer(this.dataList, {@required this.visibleCount, this.itemHeight = 150, this.expandedStateChanged});

  renderMoreItem(context) {
    return Container(
      height: 50,
      color: Colors.grey,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          // 收起，回调
          ExpandableController.of(context).toggle();
          expandedStateChanged?.call(false);
        },
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Text(
            '收起',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int decCount = dataList.length - visibleCount;
    int expandedCount = !ExpandableController.of(context).expanded ? decCount : decCount + 1;
    if (!ExpandableController.of(context).expanded) {
      return Container();
    }

    return Column(
      children: List.generate(
        expandedCount,
        (index) {
          // 只有展开才需要显示 收起按键
          if (index == decCount) {
            return renderMoreItem(context);
          }
          return InkWell(
            onTap: () => print('content $index.'),
            child: Container(
              color: Colors.pinkAccent,
              height: itemHeight,
              child: Center(
                child: Text(
                  '我是展开的 $index 内容!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

typedef ExpandedStateChanged(bool expanded);

class StickExpandModel {
  bool expanded;
  List dataList;

  StickExpandModel(this.expanded, this.dataList);
}
