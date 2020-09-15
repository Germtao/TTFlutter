import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';

/// 实现原理：
///
/// 首先我们需要一个[RepaintBoundary] Widget，并将它包裹在我们需要[toImage]的Widget当中，
/// 并给它一个[GlobalKey]，
/// 然后我们将实现一个[_capturePng()]方法，
/// 首先让[RenderRepaintBoundary]对象通过[GlobalKey]获取[RepaintBoundary]Widget的子树的[RenderObject]
/// 然后我们可以使用[RenderRepaintBoundary]的[toImage]方法将其转化为[Image]
/// 要使用[toImage]，渲染对象必须经历绘制阶段（即[debugNeedsPaint]必须为[false]）。
/// 所以当我们当前页面还未加载完毕的时候，是无法进行截图的。
/// 获取原始图像数据后，我们将其转换为[ByteData],然后再将[ByteData]转化为[Uint8List]
/// 之后我们只需要使用[Image.memory(Uint8List)]就能显示获得的图像了
///
/// 由于我们拿到的是当前页面widget产生的[renderObject]，所以生成的图片也只有当前页面
/// 需要更好的理解这句话请查看[another_demo]
class WidgetToImageDemo extends StatefulWidget {
  @override
  _WidgetToImageDemoState createState() => _WidgetToImageDemoState();
}

class _WidgetToImageDemoState extends State<WidgetToImageDemo> {
  final GlobalKey _key = GlobalKey();
  List<String> images;

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    images = List();
    _controller = ScrollController();

    fetchTen();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        fetchTen();
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
    return RepaintBoundary(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: Text('在Flutter中截屏'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            images.clear();
            fetchTen();
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
        floatingActionButton: FloatingActionButton(
          onPressed: _capturePng,
          child: Icon(Icons.fullscreen),
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String bs64 = base64Encode(pngBytes);
      print('unit8List = $pngBytes');
      print('base64 = $bs64');
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Show Image'),
            ),
            body: Container(
              child: ListView(
                children: [
                  Image.memory(pngBytes, fit: BoxFit.cover),
                ],
              ),
            ),
          );
        }));
      });

      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  fetch() async {
    final response = await Dio().get('http://dog.ceo/api/breeds/image/random');

    final model = json.decode(response.toString());

    if (model['status'] == 'success') {
      setState(() {
        images.add(model['message']);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetchTen() {
    for (int i = 0; i < 10; i++) {
      fetch();
    }
  }
}
