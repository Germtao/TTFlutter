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
  },
  "Tag 效果展示": (context) {
    return TagDemoPage();
  },
  "共享元素跳转效果": (context) {
    return HonorDemoPage();
  },
  "状态栏颜色修改（仅 App）": (context) {
    return StatusBarDemoPage();
  },
  "键盘弹出与监听（仅 App）": (context) {
    return KeyboardDemoPage();
  },
  "键盘顶起展示（仅 App）": (context) {
    return KeyboardInputBottomDemoPage();
  },
  "控件动画组合展示（旋转加放大圆）": (context) {
    return AnimDemoPage();
  },
  "控件展开动画效果": (context) {
    return AnimDemoPage2();
  },
  "全局悬浮按键效果": (context) {
    return FloatingTouchDemoPage();
  },
  "全局设置字体大小": (context) {
    return TextSizeDemoPage();
  },
  "旧版实现富文本": (context) {
    return RichTextDemoPage();
  },
  "官方实现富文本": (context) {
    return RichTextDemoPage2();
  },
  "第三方 viewpager 封装实现": (context) {
    return ViewPagerDemoPage();
  },
  "列表滑动过程控件停靠效果": (context) {
    return SliverListDemoPage();
  },
  "列表滑动停靠（Stick）": (context) {
    return StickDemoPage();
  },
  "列表滑动停靠 （Stick）+ 展开收回": (context) {
    return StickExpandDemoPage();
  },
  "列表滑动停靠效果2 （Stick）": (context) {
    return SliverStickListDemoPage();
  },
  "验证码输入框": (context) {
    return VerificationCodeInputDemoPage();
  },
  "自定义布局展示效果": (context) {
    return CustomMultiRenderDemoPage();
  },
  "自定义布局实现云词图展示": (context) {
    return CloudDemoPage();
  }
};
