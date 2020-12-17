import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './sliver_header_delegate.dart';

class SliverListDemoPage extends StatefulWidget {
  @override
  _SliverListDemoPageState createState() => _SliverListDemoPageState();
}

class _SliverListDemoPageState extends State<SliverListDemoPage> with SingleTickerProviderStateMixin {
  int listCount = 30;

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      // 头部信息
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          maxHeight: 180,
          minHeight: 180,
          vSync: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 10),
            vsync: this,
          ),
          child: Container(
            color: Colors.redAccent,
          ),
        ),
      ),

      // 动态放大缩小的tab控件
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
          maxHeight: 60,
          minHeight: 60,
          changeSize: true,
          vSync: this,
          snapConfig: FloatingHeaderSnapConfiguration(
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 10),
            vsync: this,
          ),
          builder: (context, shrinkOffset, overlapsContent) {
            // 根据数值计算偏差
            var lr = 10 - shrinkOffset / 60 * 10;
            return SizedBox(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10, left: lr, right: lr, top: lr),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.cyan,
                        child: FlatButton(
                          child: Text('按键1'),
                          onPressed: () {
                            setState(() {
                              listCount = 30;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.cyan,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              listCount = 5;
                            });
                          },
                          child: Text('按键2'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverListDemoPage'),
      ),
      body: Container(
        child: NestedScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: _sliverBuilder,
          body: ListView.builder(
            itemBuilder: (_, index) {
              return Card(
                child: Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text('Item $index'),
                ),
              );
            },
            itemCount: listCount,
          ),
        ),
      ),
    );
  }
}
