import 'package:flutter/material.dart';
import 'animation_structure_basic.dart';

// 动画基本结构及状态监听
class AnimationStructureTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('动画基本结构及状态监听')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('基础版本'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AnimationStructureBasicRoute()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
