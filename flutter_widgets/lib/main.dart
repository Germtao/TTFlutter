import 'package:flutter/material.dart';
import './widgets/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var routeLists = routes.keys.toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: routes.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => Navigator.of(context).pushNamed(routeLists[index]),
                child: Card(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: Text(routeLists[index]),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

Map<String, WidgetBuilder> routes = {
  '文本输入框简单的 Controller': (context) {
    return ControllerDemoPage();
  },
  '实现控件圆角不同组合': (context) {
    return ClipDemoPage();
  },
  '列表滑动监听': (context) {
    return ScrollListenerDemoPage();
  },
  '滑动到指定位置': (context) {
    return ScrollToIndexDemoPage();
  },
  '滑动到指定位置2': (context) {
    return ScrollToIndexDemoPage2();
  },
  'Transform 效果展示': (context) {
    return TransformDemoPage();
  },
  '计算另类文本行间距展示': (context) {
    return TextLineHeightDemoPage();
  },
  "简单上拉、下拉刷新": (context) {
    return RefreshDemoPage();
  },
  "简单上拉、下拉刷新2": (context) {
    return RefreshDemoPage2();
  },
  "通过绝对定位布局": (context) {
    return PositionedDemoPage();
  },
  "气泡提示框": (context) {
    return BubbleDemoPage();
  }
};
