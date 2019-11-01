import 'package:flutter/material.dart';

// ScrollController来控制可滚动组件的滚动位置
/*
ScrollController({
  double initialScrollOffset = 0.0, //初始滚动位置
  this.keepScrollOffset = true,//是否保存滚动位置
  ...
})
 */
class ScrollControllerTestRoute extends StatefulWidget {
  @override
  _ScrollControllerTestRouteState createState() =>
      _ScrollControllerTestRouteState();
}

class _ScrollControllerTestRouteState extends State<ScrollControllerTestRoute> {
  bool showToTopBtn = false; // 是否显示“返回到顶部”按钮
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // 监听滚动事件，打印滚动位置
    _controller.addListener(() {
      print(_controller.offset);
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && !showToTopBtn) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // 为了避免内存泄漏
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('滚动监听及控制'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Scrollbar(
        child: ListView.builder(
          itemCount: 100,
          itemExtent: 50.0, // 列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
          controller: _controller,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'List Item $index',
                style: TextStyle(color: Colors.black54),
              ),
            );
          },
        ),
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                // 返回顶部时执行动画
                _controller.animateTo(
                  .0,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.ease,
                );
              },
            ),
    );
  }
}
