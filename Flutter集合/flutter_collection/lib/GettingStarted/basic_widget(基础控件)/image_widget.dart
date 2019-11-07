import 'package:flutter/material.dart';

// 图片控件
class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imageUrl =
        'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4';
    return Scaffold(
      appBar: AppBar(
        title: Text('图片和Icon'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Image>[
            Image.network(
              imageUrl,
              width: 100.0,
              height: 50.0,
              // 会拉伸填充满显示空间，图片本身长宽比会发生变化，图片会变形
              fit: BoxFit.fill,
            ),
            Image.network(
              imageUrl,
              width: 100.0,
              height: 50.0,
              // 默认适应规则，图片会在保证图片本身长宽比不变的情况下缩放以适应当前显示空间，图片不会变形
              fit: BoxFit.contain,
            ),
            Image.network(
              imageUrl,
              width: 100.0,
              height: 50.0,
              // 会按图片的长宽比放大后居中填满显示空间，图片不会变形，超出显示空间部分会被剪裁
              fit: BoxFit.cover,
            ),
            Image.network(
              imageUrl,
              width: 100.0,
              height: 50.0,
              // 图片的宽度会缩放到显示空间的宽度，高度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁
              fit: BoxFit.fitWidth,
            ),
            Image.network(
              imageUrl,
              width: 100.0,
              height: 50.0,
              // 图片的高度会缩放到显示空间的高度，宽度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁
              fit: BoxFit.fitHeight,
            ),
            Image.network(
              imageUrl,
              width: 50.0,
              height: 100.0,
              // 图片没有适应策略，会在显示空间内显示图片，如果图片比显示空间大，则显示空间只会显示图片中间部分
              fit: BoxFit.none,
            ),
            Image.network(
              imageUrl,
              width: 100.0,
              fit: BoxFit.fill,
              // 在图片绘制时可以对每一个像素进行颜色混合处理，color指定混合色，而colorBlendMode指定混合模式
              color: Colors.blue,
              colorBlendMode: BlendMode.difference,
            ),
            Image.network(
              'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4',
              width: 100.0,
              height: 200.0,
              // 当图片本身大小小于显示空间时，指定图片的重复规则
              repeat: ImageRepeat.repeatY,
            )
          ].map((e) {
            return Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 100,
                    child: e,
                  ),
                ),
                Text(
                  e.fit.toString(),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
