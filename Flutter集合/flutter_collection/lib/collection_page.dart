import 'package:flutter/material.dart';

import 'basic_widget(基础控件)/state_manage.dart';
import 'basic_widget(基础控件)/text_widget.dart';
import 'basic_widget(基础控件)/button_widget.dart';
import 'basic_widget(基础控件)/image_widget.dart';
import 'basic_widget(基础控件)/switch_checkbox_widget.dart';
import 'basic_widget(基础控件)/textfield_widget.dart';
import 'basic_widget(基础控件)/progress_indicator_widget.dart';

import 'layout_widget(布局控件)/linear_layout.dart';
import 'layout_widget(布局控件)/flex_layout.dart';
import 'layout_widget(布局控件)/stack_positioned_layout.dart';
import 'layout_widget(布局控件)/wrap_and_flox_layout.dart';
import 'layout_widget(布局控件)/align_layout.dart';

import 'container_widget(容器类控件)/padding_widget.dart';
import 'container_widget(容器类控件)/container_widget.dart';
import 'container_widget(容器类控件)/decorated_box_widget.dart';
import 'container_widget(容器类控件)/transform_widget.dart';
import 'container_widget(容器类控件)/clip_widget.dart';
import 'container_widget(容器类控件)/尺寸限制类控件/box_widget.dart';
import 'container_widget(容器类控件)/Scaffold、TabBar、底部导航/scaffold_tab_bottom_bar.dart';

import '可滚动控件/single_child_scroll_view.dart';
import '可滚动控件/list_view.dart';
import '可滚动控件/grid_view.dart';
import '可滚动控件/custom_scroll_view.dart';
import '可滚动控件/scroll_controller.dart';

import '功能型控件/will_pop_scope.dart';
import '功能型控件/inherited_widget(数据共享)/inherited_widget_test_route.dart';

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
      default:
        break;
    }
    Navigator.of(_context)
        .push(MaterialPageRoute(builder: (context) => _pageWidget));
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
