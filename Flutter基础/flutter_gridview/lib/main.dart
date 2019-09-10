import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: new AppBar(title: new Text('GridView Widget'),),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 5.0, // 纵轴的间距
            crossAxisSpacing: 5.0, // 横轴的间距
            childAspectRatio: 0.7,
          ),
          children: <Widget>[
            new Image.network('http://img5.mtime.cn/mg/2019/09/04/141046.69013678_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/07/31/110053.38913357_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/08/19/165039.12124989_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/08/05/103716.58042294_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/05/27/100549.94746286_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/09/06/100924.14098121_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/08/30/153620.57503828_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/08/30/110842.97722482_270X405X4.jpg', fit: BoxFit.cover,),
            new Image.network('http://img5.mtime.cn/mg/2019/08/01/111416.13001281_270X405X4.jpg', fit: BoxFit.cover,),
          ],
        ),
      ),
    );
  }
}