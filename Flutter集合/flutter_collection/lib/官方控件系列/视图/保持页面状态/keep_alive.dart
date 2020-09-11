import 'package:flutter/material.dart';

class KeepPageState extends StatefulWidget {
  @override
  _KeepPageState createState() => _KeepPageState();
}

class _KeepPageState extends State<KeepPageState> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // 销毁
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keep Alive'),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              icon: Icon(Icons.directions_transit),
            ),
            Tab(
              icon: Icon(Icons.directions_bike),
            )
          ],
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          MyHomePage(),
          MyHomePage(),
          MyHomePage(),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  // 计数器
  int _counter = 0;

  @override
  bool get wantKeepAlive => true;

  // 计数器增加
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('第一次增加一个数字'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '增加数字',
        child: Icon(Icons.add),
      ),
    );
  }
}
