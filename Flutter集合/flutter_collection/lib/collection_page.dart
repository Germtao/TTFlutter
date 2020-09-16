import 'package:flutter/material.dart';
import 'package:flutter_collection/Advanced/Animation_flutter/CustomPageRoute/custom_page_route.dart';
import 'package:flutter_collection/Advanced/PackageAndPlugin/package_plugin.dart';
import 'package:flutter_collection/Advanced/PackageAndPlugin/texture.dart';
import 'package:flutter_collection/Advanced/file_network/WebSocket/WebSocket.dart';
import 'package:flutter_collection/Advanced/file_network/http_dio/http_dio.dart';
import 'package:flutter_collection/Advanced/file_network/http_download/http_download.dart';
import 'package:flutter_collection/Advanced/file_network/http_request/http_client.dart';
import 'index.dart';

import 'package:flutter_collection/官方控件系列/视图/index.dart';
import 'package:flutter_collection/官方控件系列/功能/index.dart';
import './官方控件系列/动画/index.dart';

class Entry {
  final String title;
  final List<Entry> children;

  Entry(this.title, [this.children = const <Entry>[]]);
}

class EntryItem extends StatefulWidget {
  EntryItem(this.entry);

  final Entry entry;

  @override
  _EntryItemState createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  BuildContext _context;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(
          root.title,
          style: TextStyle(fontSize: 14.0),
        ),
        onTap: () {
          _pushPage(root);
        },
      );
    } else {
      return ExpansionTile(
        title: Text(root.title),
        key: PageStorageKey<Entry>(root),
        children: root.children.map(_buildTiles).toList(),
      );
    }
  }

  void _pushPage(Entry root) {
    Widget _pageWidget;
    switch (root.title) {
      case '状态管理':
        _pageWidget = StateManager();
        break;
      case '文本、字体样式':
        _pageWidget = TextWidget();
        break;
      case '按钮':
        _pageWidget = ButtonWidget();
        break;
      case '图片和Icon':
        _pageWidget = ImageWidget();
        break;
      case '单选框和复选框':
        _pageWidget = SwitchAndCheckBoxWidget();
        break;
      case '输入框和表单':
        _pageWidget = TextFieldWidget();
        break;
      case '进度指示器':
        _pageWidget = ProgressIndicatorWidget();
        break;
      case '线性布局(Row、Column)':
        _pageWidget = LinearLayout();
        break;
      case '弹性布局(Flex)':
        _pageWidget = FlexLayout();
        break;
      case '流式布局(Wrap、Flow)':
        _pageWidget = WrapAndFloxLayout();
        break;
      case '层叠布局(Stack、Positioned)':
        _pageWidget = StackAndPositionedLayout();
        break;
      case '对齐与相对定位(Align)':
        _pageWidget = AlignLayout();
        break;

      // 容器类控件
      case '填充(Padding)':
        _pageWidget = PaddingWidget();
        break;
      case '尺寸限制类容器':
        _pageWidget = BoxWidget();
        break;
      case '装饰容器(DecoratedBox)':
        _pageWidget = DecoratedBoxWidget();
        break;
      case '变换(Transform)':
        _pageWidget = TransformWidget();
        break;
      case 'Container容器':
        _pageWidget = ContainerWidget();
        break;
      case 'Scaffold、TabBar、底部导航':
        _pageWidget = ScaffoldPageRoute();
        break;
      case '剪裁(Clip)':
        _pageWidget = ClipTestRoute();
        break;

      // 可滚动控件
      case 'SingleChildScrollView':
        _pageWidget = SingleChildScrollViewTestRoute();
        break;
      case 'ListView':
        _pageWidget = ListViewTestRoute();
        break;
      case 'GridView':
        _pageWidget = GridViewTestRoute();
        break;
      case 'CustomScrollView':
        _pageWidget = CustomScrollViewTestRoute();
        break;
      case 'ScrollController滚动监听':
        _pageWidget = ScrollControllerTestRoute();
        break;

      // 功能型控件
      case 'WillPopScope(导航返回拦截)':
        _pageWidget = WillPopScopeTestRoute();
        break;
      case 'InheritedWidget(数据共享)':
        _pageWidget = InheritedWidgetTestRoute();
        break;
      case 'Provider(跨控件状态共享)':
        _pageWidget = CartProviderRoute();
        break;
      case 'Theme(颜色和主题)':
        _pageWidget = ThemeTestRoute();
        break;
      case 'FutureBuilder、StreamBuilder(异步更新UI)':
        _pageWidget = AsyncUpdateUITestRoute();
        break;
      case '对话框':
        _pageWidget = DialogTestRoute();
        break;

      // MARK: - 进阶篇
      // 事件
      case '原始指针事件处理':
        _pageWidget = PointerEventTestRoute();
        break;
      case '手势识别':
        _pageWidget = GestureTestRoute();
        break;
      case '全局事件总线':
        break;
      case '通知':
        _pageWidget = NotificationTestRoute();
        break;

      // 动画
      case '动画结构':
        _pageWidget = AnimationStructureTestRoute();
        break;
      case '自定义路由过渡动画':
        _pageWidget = CustomPageTestRoute();
        break;
      case 'Hero动画':
        _pageWidget = HeroAnimation();
        break;
      case '交织动画':
        _pageWidget = StaggerAnimationTestRoute();
        break;
      case '通用切换动画控件':
        _pageWidget = AnimatedSwitcherCounterRoute();
        break;
      case '动画过渡控件':
        _pageWidget = AnimatedTransitionPageRoute();
        break;

      // 自定义控件
      case '组合控件':
        _pageWidget = CustomWidgetTestRoute();
        break;
      case '自绘控件':
        _pageWidget = CustomPaintTestRoute();
        break;

      // 文件操作和网络请求
      case '文件操作':
        _pageWidget = FileOperationTestRoute();
        break;
      case 'Http请求-HttpClient':
        _pageWidget = HttpClientTestRoute();
        break;
      case 'Http请求-Dio http库':
        _pageWidget = HttpDioTestRoute();
        break;
      case 'Http-分块下载':
        _pageWidget = HttpDownloadTestRoute();
        break;
      case 'WebSocket':
        _pageWidget = WebSocketTestRoute();
        break;

      // 包和插件
      case '开发Flutter插件':
        _pageWidget = BatterylevelTestRoute();
        break;
      case 'Texture(示例: 使用摄像头)':
        _pageWidget = CameraTestRoute();
        break;

      /// 官方控件系列
      /// 视图
      case 'BottomNavigationBar底部导航':
        _pageWidget = BottomNavigationWidget();
        break;
      case 'BottomAppBar底部导航':
        _pageWidget = BottomAppBarWidget();
        break;
      case '自定义路由样式':
        _pageWidget = FirstPage();
        break;
      case '高斯模糊（毛玻璃）':
        _pageWidget = FrostedClass();
        break;
      case '切换页面，保持各页面状态':
        _pageWidget = KeepPageState();
        break;
      case '制作一个精美的Material风格搜索框':
        _pageWidget = SearchBar();
        break;
      case 'TextField的焦点及动作':
        _pageWidget = TextFieldFocusDemo();
        break;
      case '微信九宫格效果':
        _pageWidget = WarpLayout();
        break;
      case '标签控件 chip系列':
        _pageWidget = ChipWidget();
        break;
      case '可展开控件 expansion系列':
        _pageWidget = ExpansionTileWidget();
        // _pageWidget = ExpandsionPanelListWidget();
        break;
      case '可滑动控件Sliver系列':
        _pageWidget = SliverScreen();
        break;
      case '使用贝塞尔二阶曲线切割图像':
        _pageWidget = WaveBezierCurveDemo();
        break;
      case '用户可以通过拖动以交互方式重新排序的项目的列表':
        _pageWidget = ReorderableListViewDemo();
        break;

      /// 功能
      case '返回上一页时弹出提示信息':
        // _pageWidget = WillPopScpoeDemo(title: '返回上一页时弹出提示信息');
        _pageWidget = FormPopDemo();
        break;
      case '应用开启进入闪屏页':
        _pageWidget = SplashScreenAnimation();
        break;
      case '上拉加载，下拉刷新':
        // _pageWidget = GridViewRefreshDemo();
        _pageWidget = ListViewRefreshDemo();
        break;
      case '左滑删除ListView中Item':
        _pageWidget = SwipeToDismissDemo();
        break;
      case '右滑返回上一页':
        _pageWidget = SwipeRightBackDemo();
        break;
      case '在flutter中截屏':
        _pageWidget = WidgetToImageDemo();
        break;
      case '轻量级操作提示控件toolstip':
        _pageWidget = ToolTipsDemo();
        break;
      case '可拖动组件draggable':
        _pageWidget = DraggableDemo();
        break;
      case '去掉点击事件的水波纹效果':
        _pageWidget = WithOutSplashColorDemo();
        break;
      case '在当前页面上覆盖新的组件overlay':
        // _pageWidget = OverlayDemo();
        // _pageWidget = OverlayDemo2();
        _pageWidget = OverlayDemo3();
        break;
      case '在不同页面传递事件EventBus':
        _pageWidget = FirstScreen();
        break;
      case '自定义 Navigator':
        _pageWidget = CustomNavigatorApp();
        break;

      /// 动画
      case '基础动画':
        _pageWidget = BasicAnimationDemo();
        break;
      case '延迟动画':
        _pageWidget = DelayedAnimationDemo();
        break;
      case '父子动画':
        // _pageWidget = ParentAnimationDemo();
        _pageWidget = AnotherParentAnimationDemo();
        break;
      default:
        return;
    }
    Navigator.of(_context).push(MaterialPageRoute(builder: (context) => _pageWidget));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _buildTiles(widget.entry);
  }
}

class CollectionPage extends StatelessWidget {
  final List<Entry> data = <Entry>[
    Entry('入门篇', <Entry>[
      Entry('基础控件', <Entry>[
        Entry('状态管理'),
        Entry('文本、字体样式'),
        Entry('按钮'),
        Entry('图片和Icon'),
        Entry('单选框和复选框'),
        Entry('输入框和表单'),
        Entry('进度指示器')
      ]),
      Entry('布局类控件', <Entry>[
        Entry('线性布局(Row、Column)'),
        Entry('弹性布局(Flex)'),
        Entry('流式布局(Wrap、Flow)'),
        Entry('层叠布局(Stack、Positioned)'),
        Entry('对齐与相对定位(Align)'),
      ]),
      Entry('容器类控件', <Entry>[
        Entry('填充(Padding)'),
        Entry('尺寸限制类容器'),
        Entry('装饰容器(DecoratedBox)'),
        Entry('变换(Transform)'),
        Entry('Container容器'),
        Entry('Scaffold、TabBar、底部导航'),
        Entry('剪裁(Clip)')
      ]),
      Entry('可滚动控件', <Entry>[
        Entry('SingleChildScrollView'),
        Entry('ListView'),
        Entry('GridView'),
        Entry('CustomScrollView'),
        Entry('ScrollController滚动监听')
      ]),
      Entry('功能型控件', <Entry>[
        Entry('WillPopScope(导航返回拦截)'),
        Entry('InheritedWidget(数据共享)'),
        Entry('Provider(跨控件状态共享)'),
        Entry('Theme(颜色和主题)'),
        Entry('FutureBuilder、StreamBuilder(异步更新UI)'),
        Entry('对话框'),
      ]),
    ]),
    // 进阶篇
    Entry('进阶篇', <Entry>[
      Entry('事件处理与通知', <Entry>[
        Entry('原始指针事件处理'),
        Entry('手势识别'),
        Entry('全局事件总线'),
        Entry('通知'),
      ]),
      Entry('动画', <Entry>[
        Entry('动画结构'),
        Entry('自定义路由过渡动画'),
        Entry('Hero动画'),
        Entry('交织动画'),
        Entry('通用切换动画控件'),
        Entry('动画过渡控件'),
      ]),
      Entry('自定义控件', <Entry>[
        Entry('组合控件'),
        Entry('自绘控件'),
      ]),
      Entry('文件操作和网络请求', <Entry>[
        Entry('文件操作'),
        Entry('Http请求-HttpClient'),
        Entry("Http请求-Dio http库"),
        Entry("Http-分块下载"),
        Entry('WebSocket'),
      ]),
      Entry('包和插件', <Entry>[Entry('开发Flutter插件'), Entry('Texture(示例: 使用摄像头)')]),
    ]),

    /// UI
    Entry('官方控件系列', <Entry>[
      Entry('视图', <Entry>[
        Entry('BottomNavigationBar底部导航'),
        Entry('BottomAppBar底部导航'),
        Entry('自定义路由样式'),
        Entry('高斯模糊（毛玻璃）'),
        Entry('切换页面，保持各页面状态'),
        Entry('制作一个精美的Material风格搜索框'),
        Entry('TextField的焦点及动作'),
        Entry('微信九宫格效果'),
        Entry('标签控件 chip系列'),
        Entry('可展开控件 expansion系列'),
        Entry('可滑动控件Sliver系列'),
        Entry('使用贝塞尔二阶曲线切割图像'),
        Entry('用户可以通过拖动以交互方式重新排序的项目的列表'),
      ]),
      Entry('功能', <Entry>[
        Entry('返回上一页时弹出提示信息'),
        Entry('应用开启进入闪屏页'),
        Entry('上拉加载，下拉刷新'),
        Entry('左滑删除ListView中Item'),
        Entry('右滑返回上一页'),
        Entry('在flutter中截屏'),
        Entry('轻量级操作提示控件toolstip'),
        Entry('可拖动组件draggable'),
        Entry('去掉点击事件的水波纹效果'),
        Entry('在当前页面上覆盖新的组件overlay'),
        Entry('在不同页面传递事件EventBus'),
        Entry('自定义 Navigator'),
      ]),
      Entry('动画', <Entry>[
        Entry('基础动画'),
        Entry('延迟动画'),
        Entry('父子动画'),
        Entry('左滑删除ListView中Item'),
        Entry('右滑返回上一页'),
        Entry('在flutter中截屏'),
        Entry('轻量级操作提示控件toolstip'),
        Entry('可拖动组件draggable'),
        Entry('去掉点击事件的水波纹效果'),
        Entry('在当前页面上覆盖新的组件overlay'),
        Entry('在不同页面传递事件EventBus'),
        Entry('自定义 Navigator'),
      ]),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter集合'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}
