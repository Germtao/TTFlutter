import 'package:flutter/material.dart';

class WarpLayout extends StatefulWidget {
  @override
  _WarpLayoutState createState() => _WarpLayoutState();
}

class _WarpLayoutState extends State<WarpLayout> {
  List<Widget> list;

  @override
  void initState() {
    super.initState();
    list = List<Widget>()..add(buildButton());
  }

  @override
  Widget build(BuildContext context) {
    // 屏幕的宽度
    final width = MediaQuery.of(context).size.width;
    // 屏幕的高度
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('流式布局'),
      ),
      body: Center(
        child: Opacity(
          opacity: 0.8,
          child: Container(
            width: width,
            height: height / 2,
            color: Colors.grey,
            child: Wrap(
              children: list,
              spacing: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  // 添加按钮
  Widget buildButton() {
    return GestureDetector(
      onTap: () {
        if (list.length <= 10) {
          setState(() {
            list.insert(list.length - 1, buildPhoto());
            if (list.length == 10) {
              list.removeLast();
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
        child: Container(
          width: 80.0,
          height: 80.0,
          color: Colors.black54,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // 添加的图片widget
  Widget buildPhoto() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      child: Container(
        width: 80.0,
        height: 80.0,
        color: Colors.amber,
        child: Center(
          child: Text('照片'),
        ),
      ),
    );
  }
}

List<Widget> list;
