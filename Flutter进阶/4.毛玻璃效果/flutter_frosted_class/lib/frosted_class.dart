/**
 * 使用BackdropFilter实现毛玻璃效果,且子部件需要设置Opacity
 * 使用这个部件的代价很高，尽量少用
 * ImageFilter.blur的sigmaX/Y决定了毛玻璃的模糊程度，值越高越模糊
 * 一般来说，为了防止模糊效果绘制出边界，需要使用ClipRect Widget包裹
 */
import 'package:flutter/material.dart';
import 'dart:ui';

class FrostedClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 约束盒子组件, 添加额外的限制约束为child
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.network(
              'http://img5.mtime.cn/mg/2019/05/31/163641.36482297_270X405X4.jpg',
            ),
          ),
          Center(
            // 可裁切的矩形组件
            child: ClipRect(
              // 背景过滤器
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: 275.0,
                    height: 410.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: Center(
                      child: Text(
                        '蜘蛛侠：英雄远征',
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
