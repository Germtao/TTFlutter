import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文本、字体样式'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Hello World',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18.0,
              height: 2.0, // 该属性用于指定行高，但它并不是一个绝对值，而是一个因子，具体的行高等于fontSize*height
              fontFamily: 'Courier', // 由于不同平台默认支持的字体集不同，所以在手动指定字体时一定要先在不同平台测试一下
              background: Paint()..color = Colors.yellow,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
            ),
          ),
          Text(
            'Hello World' * 8, // 字符串重复8次
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // 超出...省略
            textScaleFactor: 1.5,
          ),
          // 对一个Text内容的不同部分按照不同的样式显示
          Text.rich(TextSpan(
            children: [
              TextSpan(text: 'Home: '),
              TextSpan(
                text: 'https://www.baidu.com',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          )),
          // 设置默认样式
          DefaultTextStyle(
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hello World'),
                Text('Flutter Text Widget'),
                Text(
                  'Flutter Demo',
                  style: TextStyle(
                    inherit: false, // 不继承默认样式
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
