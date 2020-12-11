import 'dart:ffi';

import 'package:flutter/material.dart';

/// 刷新演示
/// 比较粗略，没有做互斥等
class RefreshDemoPage extends StatefulWidget {
  @override
  _RefreshDemoPageState createState() => _RefreshDemoPageState();
}

class _RefreshDemoPageState extends State<RefreshDemoPage> {
  final int pageSize = 30;

  bool disposed = false;

  List<String> dataList = List();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // 判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });

    Future.delayed(Duration(seconds: 0), () {
      refreshKey.currentState.show();
    });
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    dataList.clear();

    for (int i = 0; i < pageSize; i++) {
      dataList.add('refresh');
    }

    if (disposed) {
      return;
    }

    setState(() {});
  }

  Future<void> loadMore() async {
    await Future.delayed(Duration(seconds: 2));

    for (int i = 0; i < pageSize; i++) {
      dataList.add('loadMore');
    }

    if (disposed) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshDemoPage'),
      ),
      body: Container(
        child: RefreshIndicator(
          // GlobalKey，用户外部获取RefreshIndicator的State，做显示刷新
          key: refreshKey,

          // 下拉刷新触发，返回一个 Future
          onRefresh: onRefresh,
          child: ListView.builder(
            // 保持 ListView 任何情况都能滚动，解决在 RefreshIndicator 的兼容问题
            physics: const AlwaysScrollableScrollPhysics(),

            // 滑动监听
            controller: _scrollController,

            // 根据状态返回数量
            itemCount: (dataList.length >= pageSize) ? dataList.length + 1 : dataList.length,

            // 根据状态返回
            itemBuilder: (BuildContext context, int index) {
              if (index == dataList.length) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: Align(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Card(
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Text('Item ${dataList[index]} - $index'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
