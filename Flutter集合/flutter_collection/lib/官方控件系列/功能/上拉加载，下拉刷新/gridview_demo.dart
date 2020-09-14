import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GridViewRefreshDemo extends StatefulWidget {
  @override
  _GridViewRefreshDemoState createState() => _GridViewRefreshDemoState();
}

class _GridViewRefreshDemoState extends State<GridViewRefreshDemo> {
  ScrollController _controller;
  List<String> images;

  @override
  void initState() {
    super.initState();
    images = List();
    _controller = ScrollController();
    fetchThen();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        fetchThen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView-上拉、下拉刷新'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          images.clear();
          fetchThen();
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1,
          ),
          controller: _controller,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _buildItem(images[index]);
          },
        ),
      ),
    );
  }

  Widget _buildItem(String url) {
    return Container(
      constraints: BoxConstraints.tightFor(height: 150.0),
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }

  fetch() async {
    final response = await Dio().get('http://dog.ceo/api/breeds/image/random');

    print('请求的数据: $response');

    final model = json.decode(response.toString());

    if (model['status'] == 'success') {
      setState(() {
        images.add(model['message']);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetchThen() {
    for (int i = 0; i < 10; i++) {
      fetch();
    }
  }
}
