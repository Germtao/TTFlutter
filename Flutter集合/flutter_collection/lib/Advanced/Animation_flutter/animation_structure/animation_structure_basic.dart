import 'package:flutter/material.dart';

// 动画基本结构 基础版本
class AnimationStructureBasicRoute extends StatefulWidget {
  @override
  _AnimationStructureBasicRouteState createState() =>
      _AnimationStructureBasicRouteState();
}

// 需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin。
class _AnimationStructureBasicRouteState
    extends State<AnimationStructureBasicRoute> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    // 使用弹性曲线
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);

    // 图片宽高从0变到300
    animation = Tween(begin: 0.0, end: 300.0).animate(animation)
      ..addListener(() {
        setState(() => {});
      });

    // 启动动画（正向执行）
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('基础版本 - 放大动画')),
        body: Center(
          child: Image.asset(
            'images/scale.png',
            width: animation.value,
            height: animation.value,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}
