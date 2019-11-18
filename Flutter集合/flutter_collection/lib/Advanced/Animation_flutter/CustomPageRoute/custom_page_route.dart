import 'package:flutter/material.dart';
import 'page_common.dart';
import 'fade_route.dart';

// 自定义路由过渡动画
class CustomPageTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('自定义路由过渡动画')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //     transitionDuration: Duration(milliseconds: 500),
                  //     pageBuilder: (context, animation, secondaryAnimation) {
                  //       // 使用渐隐渐入过渡
                  //       return FadeTransition(
                  //         opacity: animation,
                  //         child: PageTestRoute(),
                  //       );
                  //     },
                  //   ),
                  // );
                  Navigator.push(context, FadeRoute(builder: (context) {
                    return PageTestRoute();
                  }));
                },
                child: Text('渐隐渐入过渡'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
