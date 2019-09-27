import 'package:flutter/material.dart';
import 'basic_widget(基础控件)/state_manage.dart';
import 'basic_widget(基础控件)/text_widget.dart';
import 'basic_widget(基础控件)/button_widget.dart';

class Entry {
  final String title;
  final List<Entry> children;

  Entry(this.title, [this.children = const <Entry>[]]);
}

class EntryItem extends StatelessWidget {
  EntryItem(this.entry);

  final Entry entry;

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
      default:
        break;
    }
    Navigator.of(_context)
        .push(MaterialPageRoute(builder: (context) => _pageWidget));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _buildTiles(entry);
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
      ])
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
