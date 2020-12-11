import 'package:flutter/material.dart';

/// 滑动监听
class ScrollListenerDemoPage extends StatefulWidget {
  @override
  _ScrollListenerDemoPageState createState() => _ScrollListenerDemoPageState();
}

class _ScrollListenerDemoPageState extends State<ScrollListenerDemoPage> {
  final ScrollController _scrollController = ScrollController();

  bool isEnd = false;

  double offset = 0.0;

  String notify = "";

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        offset = _scrollController.offset;
        isEnd = _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollListenerDemoPage'),
      ),
      body: Container(
        child: NotificationListener(
          onNotification: (notification) {
            String notify = "";
            if (notification is ScrollEndNotification) {
              notify = "ScrollEnd";
            } else if (notification is ScrollStartNotification) {
              notify = "ScrollStart";
            } else if (notification is UserScrollNotification) {
              notify = "UserScroll";
            } else if (notification is ScrollUpdateNotification) {
              notify = "ScrollUpdate";
            }

            setState(() {
              this.notify = notify;
            });

            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Text('Item $index'),
                ),
              );
            },
          ),
        ),
      ),
      persistentFooterButtons: [
        FlatButton(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: Duration(seconds: 1),
              curve: Curves.bounceInOut,
            );
          },
          child: Text('position: ${offset.floor()}'),
        ),
        Container(
          width: 0.3,
          height: 30,
        ),
        FlatButton(
          onPressed: () {},
          child: Text(this.notify),
        ),
        Visibility(
          visible: isEnd,
          child: FlatButton(
            onPressed: () {},
            child: Text('到底了'),
          ),
        )
      ],
    );
  }
}
