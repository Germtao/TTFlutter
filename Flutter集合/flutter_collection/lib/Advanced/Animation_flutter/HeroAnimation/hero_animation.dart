import 'package:flutter/material.dart';

// 路由A
class HeroAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Hero 动画')),
        body: Container(
          alignment: Alignment.center,
          child: InkWell(
            child: Hero(
              tag: 'avatar', // 唯一标记，前后两个路由页Hero的tag必须相同
              child: ClipOval(
                child: FlutterLogo(size: 50),
              ),
            ),
            onTap: () {
              // 打开路由B
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: HeroAnimationRouteB(),
                );
              }));
            },
          ),
        ),
      ),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'avatar', // 唯一标记，前后两个路由页Hero的tag必须相同
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset('images/scale.png'),
        ),
      ),
    );
  }
}
