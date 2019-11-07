import 'package:flutter/material.dart';

// ThemeData 用于保存是Material组件库的主题数据，
// Material组件需要遵守相应的设计规范，而这些规范可自定义部分都定义在ThemeData中了，
// 所以我们可以通过ThemeData来自定义应用主题。在子组件中，我们可以通过Theme.of方法来获取当前的ThemeData
/*
ThemeData({
  Brightness brightness, //深色还是浅色
  MaterialColor primarySwatch, //主题颜色样本，见下面介绍
  Color primaryColor, //主色，决定导航栏颜色
  Color accentColor, //次级色，决定大多数Widget的颜色，如进度条、开关等。
  Color cardColor, //卡片颜色
  Color dividerColor, //分割线颜色
  ButtonThemeData buttonTheme, //按钮主题
  Color cursorColor, //输入框光标颜色
  Color dialogBackgroundColor,//对话框背景颜色
  String fontFamily, //文字字体
  TextTheme textTheme,// 字体主题，包括标题、body等文字样式
  IconThemeData iconTheme, // Icon的默认样式
  TargetPlatform platform, //指定平台，应用特定平台控件风格
  ...
})
 */
class ThemeTestRoute extends StatefulWidget {
  @override
  _ThemeTestRouteState createState() => _ThemeTestRouteState();
}

class _ThemeTestRouteState extends State<ThemeTestRoute> {
  Color _themeColor = Colors.teal; // 当前路由主题色

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: ThemeData(
        primaryColor: _themeColor, // 用于导航栏、FloatingActionButton的背景色等
        iconTheme: IconThemeData(color: _themeColor), // 用于Icon颜色
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('主题测试'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 第一行Icon使用主题中的iconTheme
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.favorite),
                Icon(Icons.airport_shuttle),
                Text('  颜色跟随主题'),
              ],
            ),

            // 为第二行Icon自定义颜色（固定为黑色)
            Theme(
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(
                  color: Colors.black,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite),
                  Icon(Icons.airport_shuttle),
                  Text('  颜色固定黑色'),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _themeColor =
                  _themeColor == Colors.teal ? Colors.blueAccent : Colors.teal;
            });
          },
          backgroundColor: _themeColor,
          child: Icon(Icons.palette),
        ),
      ),
    );
  }
}
