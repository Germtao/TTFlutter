import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Container Widget',
      home: Scaffold(
        body: Center(
          child: new Container(
            child: new Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1567074681578&di=25465c1237837d91634421e173a32b65&imgtype=0&src=http%3A%2F%2Fpic4.zhimg.com%2Fv2-f51a87a4313286675d9750b9c5d1c42b_xl.jpg',
//              fit: BoxFit.fill,
//              color: Colors.greenAccent,
//              colorBlendMode: BlendMode.modulate,
              repeat: ImageRepeat.repeat,
            ),
            width: 300,
            height: 300,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
