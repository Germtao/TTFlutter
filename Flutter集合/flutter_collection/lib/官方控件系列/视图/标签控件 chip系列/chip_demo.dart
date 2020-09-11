import 'package:flutter/material.dart';
import 'chip_page.dart';

class ChipWidget extends StatefulWidget {
  @override
  _ChipWidgetState createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> _list = ['Default', 'Action', 'Filter', 'Choice', 'Input'];

  List<Tab> _tabList = [];

  List<Widget> _pageList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _list.forEach((value) {
      _tabList.add(
        Tab(
          child: Text(
            value,
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
      _pageList.add(ChipPage(type: value));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('标签控件 Chip系列'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabList,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pageList,
      ),
    );
  }
}
