import 'dart:async';

import 'package:flutter/material.dart';

class AsyncUpdateUITestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('异步更新UI'),
        ),
        // body: _futureBuilder(),
        body: _streamBuilder(),
      ),
    );
  }

  // 1. FutureBuilder
  Future<String> mockNetworkData() async {
    var duration = Duration(seconds: 2);
    return Future.delayed(duration, () => '从互联网上获取的数据');
  }

  Widget _futureBuilder() {
    return Center(
      child: FutureBuilder<String>(
        future: mockNetworkData(), // FutureBuilder依赖的Future，通常是一个异步耗时任务
        // snapshot会包含当前异步任务的状态信息及结果信息
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误信息
              return Text('Error: ${snapshot.error}');
            } else {
              // 请求成功
              return Text('Contents: ${snapshot.data}');
            }
          } else {
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  // 2. StreamBuilder
  // 在Dart中Stream 也是用于接收异步事件数据，
  // 和Future 不同的是，它可以接收多个异步操作的结果，它常用于会多次读取数据的异步任务场景，如网络内容下载、文件读写等。
  Stream<int> counter() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      return i;
    });
  }

  Widget _streamBuilder() {
    return Center(
      child: StreamBuilder<int>(
        stream: counter(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('没有Stream');
            case ConnectionState.waiting:
              return Text('等待数据...');
            case ConnectionState.active:
              return Text('active: ${snapshot.data}');
            case ConnectionState.done:
              return Text('Stream关闭');
          }
          return null;
        },
      ),
    );
  }
}
