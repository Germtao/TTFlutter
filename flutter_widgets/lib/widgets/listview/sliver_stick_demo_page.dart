import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './sliver_header_delegate.dart';

/// 用 Sliver 的模式实现 Stick
/// 目前的实现方式就是性能不大好
class SliverStickListDemoPage extends StatefulWidget {
  @override
  _SliverStickListDemoPageState createState() => _SliverStickListDemoPageState();
}

class _SliverStickListDemoPageState extends State<SliverStickListDemoPage> {
  ScrollController scrollController = ScrollController();

  var slivers = List<Widget>();

  final double headerHeight = 60;
  final double contentHeight = 120;

  void initItem() {
    slivers.clear();
    for (var i = 0; i < 50; i++) {
      // 头
      slivers.add(
        SliverHeaderItem(
          i,
          child: Container(
            height: headerHeight,
            alignment: Alignment.center,
            color: Colors.redAccent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              height: headerHeight,
              child: Text('Header - $i'),
            ),
          ),
          headerHeight: headerHeight,
          contentHeight: contentHeight,
        ),
      );

      // 内容
      slivers.add(
        SliverToBoxAdapter(
          child: Container(
            height: contentHeight,
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text('Content - $i'),
          ),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        initItem();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverStickListDemoPage'),
      ),
      body: Container(
        child: CustomScrollView(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: slivers,
        ),
      ),
    );
  }
}

class SliverHeaderItem extends StatefulWidget {
  final int index;
  final Widget child;
  final double headerHeight;
  final double contentHeight;

  SliverHeaderItem(this.index, {@required this.child, this.headerHeight = 60, this.contentHeight = 120});

  @override
  _SliverHeaderItemState createState() => _SliverHeaderItemState();
}

class _SliverHeaderItemState extends State<SliverHeaderItem> with SingleTickerProviderStateMixin {
  scrollListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // 监听列表改变
    Future.delayed(Duration(seconds: 0), () {
      Scrollable.of(context).position.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    Scrollable.of(context).position.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: SliverHeaderDelegate(
        minHeight: widget.headerHeight,
        maxHeight: widget.headerHeight,
        vSync: this,
        snapConfig: FloatingHeaderSnapConfiguration(
          curve: Curves.bounceInOut,
          duration: Duration(milliseconds: 10),
          vsync: this,
        ),
        builder: (context, shrinkOffset, overlapsContent) {
          var state = Scrollable.of(context);

          // 整个 item 的高度
          var itemHeight = widget.headerHeight + widget.contentHeight;

          // 当前顶部的位置
          var position = state.position.pixels ~/ itemHeight;

          // 当前和挂着的 header 相邻的 item 位置
          var offsetPosition = (state.position.pixels + widget.headerHeight) ~/ itemHeight;

          // 当前和挂着的 header 相邻的 item，需要改变的偏移
          var changeOffset = state.position.pixels - offsetPosition * itemHeight;

          // header 动态显示需要的高度
          var height = offsetPosition == (widget.index + 1)
              ? (changeOffset < 0 ? -changeOffset : widget.headerHeight)
              : widget.headerHeight;

          return Visibility(
            visible: position <= widget.index,
            child: Transform.translate(
              offset: Offset(0, -(widget.headerHeight - height)),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
