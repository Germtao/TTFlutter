import 'package:flutter/material.dart';
import 'package:flutter_collection/GettingStarted/container_widget(容器类控件)/尺寸限制类控件/constrained_box_widget.dart';
import 'package:flutter_collection/GettingStarted/container_widget(容器类控件)/尺寸限制类控件/multiple_limit_box_widget.dart';
import 'package:flutter_collection/GettingStarted/container_widget(容器类控件)/尺寸限制类控件/sized_box_widget.dart';
import 'package:flutter_collection/GettingStarted/container_widget(容器类控件)/尺寸限制类控件/unconstrained_box_widget.dart';

// 尺寸限制类容器
// ConstrainedBox、SizedBox、多重限制、UnconstrainedBox等
class BoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('尺寸限制类控件'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('ConstrainedBox'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ConstrainedBoxWidget(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text('SizedBox'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SizedBoxWidget(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text('多重限制'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultipleLimitBoxWidget(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text('UnconstrainedBox'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UnConstrainedBoxWidget(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
