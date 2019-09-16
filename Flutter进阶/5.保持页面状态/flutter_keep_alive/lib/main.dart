import 'package:flutter/material.dart';
import 'keep_alive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Alive',
      home: KeepAlive(),
    );
  }
}

class KeepAlive extends StatefulWidget {
  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive>
    with SingleTickerProviderStateMixin {
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
