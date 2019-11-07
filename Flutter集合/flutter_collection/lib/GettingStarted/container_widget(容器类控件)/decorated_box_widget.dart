import 'package:flutter/material.dart';

// DecoratedBox可以在其子组件绘制前(或后)绘制一些装饰（Decoration），如背景、边框、渐变等
/*
BoxDecoration({
  Color color, //颜色
  DecorationImage image,//图片
  BoxBorder border, //边框
  BorderRadiusGeometry borderRadius, //圆角
  List<BoxShadow> boxShadow, //阴影,可以指定多个
  Gradient gradient, //渐变
  BlendMode backgroundBlendMode, //背景混合模式
  BoxShape shape = BoxShape.rectangle, //形状
})
 */
class DecoratedBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('装饰容器(DecoratedBox)'),
      ),
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, Colors.orange[700]]), // 背景渐变
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 18.0),
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
