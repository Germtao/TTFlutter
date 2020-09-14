import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ListViewRefreshDemo extends StatefulWidget {
  @override
  _ListViewRefreshDemoState createState() => _ListViewRefreshDemoState();
}

class _ListViewRefreshDemoState extends State<ListViewRefreshDemo> {
  ScrollController _controller;
  List<String> images;

  @override
  void initState() {
    super.initState();
    images = List<String>();
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
        title: Text('ListView - 下拉、上拉刷新'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          images.clear();
          fetchThen();
        },
        child: ListView.builder(
          controller: _controller,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              constraints: BoxConstraints.tightFor(height: 150.0),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
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
