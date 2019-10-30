import 'package:flutter/material.dart';
import 'package:flutter_collection/container_widget(%E5%AE%B9%E5%99%A8%E7%B1%BB%E6%8E%A7%E4%BB%B6)/%E5%B0%BA%E5%AF%B8%E9%99%90%E5%88%B6%E7%B1%BB%E6%8E%A7%E4%BB%B6/constrained_box_widget.dart';
import 'package:flutter_collection/container_widget(%E5%AE%B9%E5%99%A8%E7%B1%BB%E6%8E%A7%E4%BB%B6)/%E5%B0%BA%E5%AF%B8%E9%99%90%E5%88%B6%E7%B1%BB%E6%8E%A7%E4%BB%B6/multiple_limit_box_widget.dart';
import 'package:flutter_collection/container_widget(%E5%AE%B9%E5%99%A8%E7%B1%BB%E6%8E%A7%E4%BB%B6)/%E5%B0%BA%E5%AF%B8%E9%99%90%E5%88%B6%E7%B1%BB%E6%8E%A7%E4%BB%B6/sized_box_widget.dart';
import 'package:flutter_collection/container_widget(%E5%AE%B9%E5%99%A8%E7%B1%BB%E6%8E%A7%E4%BB%B6)/%E5%B0%BA%E5%AF%B8%E9%99%90%E5%88%B6%E7%B1%BB%E6%8E%A7%E4%BB%B6/unconstrained_box_widget.dart';

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
