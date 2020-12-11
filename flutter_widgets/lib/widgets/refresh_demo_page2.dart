import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 刷新演示2
/// 比较粗略，没有做互斥等
class RefreshDemoPage2 extends StatefulWidget {
  @override
  _RefreshDemoPage2State createState() => _RefreshDemoPage2State();
}

class _RefreshDemoPage2State extends State<RefreshDemoPage2> {
  final int pageSize = 30;

  bool disposed = false;

  List<String> dataList = List();

  final ScrollController _scrollController = ScrollController();

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 直接触发下拉刷新
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.animateTo(
        -141,
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshDemoPage2'),
      ),
      body: Container(
        child: NotificationListener(
          onNotification: (notification) {
            // 判断当前滑动位置是不是到达底部，触发加载更多回调
            if (notification is ScrollEndNotification) {
              if (_scrollController.position.pixels > 0 &&
                  _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
                loadMore();
              }
            }

            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,

            // 回弹效果
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // 控制显示刷新的 CupertinoSliverRefreshControl
              CupertinoSliverRefreshControl(
                refreshIndicatorExtent: 100,
                refreshTriggerPullDistance: 140,
                onRefresh: onRefresh,
              ),

              // 列表区域
              SliverSafeArea(
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
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
                    childCount: (dataList.length >= pageSize) ? dataList.length + 1 : dataList.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
