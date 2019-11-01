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
      body: _gridViewWithMaxCrossAxisExtentEuqal,
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
