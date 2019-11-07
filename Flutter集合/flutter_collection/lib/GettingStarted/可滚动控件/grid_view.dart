import 'package:flutter/material.dart';

// GridView可以构建一个二维网格列表
/*
GridView({
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  ScrollController controller,
  bool primary,
  ScrollPhysics physics,
  bool shrinkWrap = false,
  EdgeInsetsGeometry padding,
  @required SliverGridDelegate gridDelegate, //控制子widget layout的委托
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  double cacheExtent,
  List<Widget> children = const <Widget>[],
})
 */
class GridViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      // body: _gridViewWithFixedCrossAxisCount,
      // body: _gridViewWithFixedCrossAxisCountEuqal,

      // body: _gridViewWithMaxCrossAxisExtent,
      // body: _gridViewWithMaxCrossAxisExtentEuqal,

      body: InfiniteGridView(),
    );
  }

  // SliverGridDelegateWithFixedCrossAxisCount
  /*
  SliverGridDelegateWithFixedCrossAxisCount({
    @required double crossAxisCount, // 横轴子元素的数量, 指定后子元素横轴长度就确定了
    double mainAxisSpacing = 0.0,    // 主轴方向的间距
    double crossAxisSpacing = 0.0,   // 横轴方向子元素的间距
    double childAspectRatio = 1.0,   // 子元素在横轴长度和主轴长度的比例，可以确定子元素在主轴的长度
})
   */
  Widget _gridViewWithFixedCrossAxisCount = GridView(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
    children: <Widget>[
      Icon(Icons.ac_unit, color: Colors.blueAccent),
      Icon(Icons.airport_shuttle, color: Colors.blueAccent),
      Icon(Icons.all_inclusive, color: Colors.blueAccent),
      Icon(Icons.beach_access, color: Colors.blueAccent),
      Icon(Icons.cake, color: Colors.blueAccent),
      Icon(Icons.free_breakfast, color: Colors.blueAccent),
    ],
  );

  Widget _gridViewWithFixedCrossAxisCountEuqal = GridView.count(
    crossAxisCount: 3,
    children: <Widget>[
      Icon(Icons.ac_unit, color: Colors.redAccent),
      Icon(Icons.airport_shuttle, color: Colors.redAccent),
      Icon(Icons.all_inclusive, color: Colors.redAccent),
      Icon(Icons.beach_access, color: Colors.redAccent),
      Icon(Icons.cake, color: Colors.redAccent),
      Icon(Icons.free_breakfast, color: Colors.redAccent),
    ],
  );

  // SliverGridDelegateWithMaxCrossAxisExtent
  /*
  SliverGridDelegateWithMaxCrossAxisExtent({
    double maxCrossAxisExtent,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
  })
   */
  Widget _gridViewWithMaxCrossAxisExtent = GridView(
    padding: EdgeInsets.zero,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 120.0,
      childAspectRatio: 2.0,
    ),
    children: <Widget>[
      Icon(Icons.ac_unit, color: Colors.blueAccent),
      Icon(Icons.airport_shuttle, color: Colors.blueAccent),
      Icon(Icons.all_inclusive, color: Colors.blueAccent),
      Icon(Icons.beach_access, color: Colors.blueAccent),
      Icon(Icons.cake, color: Colors.blueAccent),
      Icon(Icons.free_breakfast, color: Colors.blueAccent),
    ],
  );

  Widget _gridViewWithMaxCrossAxisExtentEuqal = GridView.extent(
    maxCrossAxisExtent: 120.0,
    childAspectRatio: 2.0,
    children: <Widget>[
      Icon(Icons.ac_unit, color: Colors.redAccent),
      Icon(Icons.airport_shuttle, color: Colors.redAccent),
      Icon(Icons.all_inclusive, color: Colors.redAccent),
      Icon(Icons.beach_access, color: Colors.redAccent),
      Icon(Icons.cake, color: Colors.redAccent),
      Icon(Icons.free_breakfast, color: Colors.redAccent),
    ],
  );
}

// 实现：从一个异步数据源（如网络）分批获取一些 Icon
class InfiniteGridView extends StatefulWidget {
  @override
  _InfiniteGridViewState createState() => _InfiniteGridViewState();
}

class _InfiniteGridViewState extends State<InfiniteGridView> {
  List<IconData> _icons = []; // 保存Icon数据

  @override
  void initState() {
    super.initState();
    // 初始化数据
    _retrieveIcons();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        // 如果显示到最后一个并且Icon总数小于200时继续获取数据
        if (index == _icons.length - 1 && _icons.length < 200) {
          _retrieveIcons();
        }

        return Icon(_icons[index], color: Colors.blueAccent);
      },
    );
  }

  // 模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        _icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast,
        ]);
      });
    });
  }
}
