import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

// ListView是最常用的可滚动组件之一，它可以沿一个方向线性排布所有子组件，并且它也支持基于Sliver的延迟构建模型
/*
ListView({
  ...  
  //可滚动widget公共参数
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  ScrollController controller,
  bool primary,
  ScrollPhysics physics,
  EdgeInsetsGeometry padding,

  //ListView各个构造函数的共同参数  
  double itemExtent,
  bool shrinkWrap = false,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  double cacheExtent,

  //子widget列表
  List<Widget> children = const <Widget>[],
})
 */

class ListViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      // body: _listView1,
      // body: _listView2,
      // body: _listView3,
      body: InfiniteListView(),
    );
  }

  // 1. 类似 SingleChildScrollView+Column 的效果
  // 可滚动组件通过一个List来作为其children属性时，只适用于子组件较少的情况，
  // 这是一个通用规律，并非ListView自己的特性，像GridView也是如此
  final Widget _listView1 = ListView(
    shrinkWrap: true, // 是否根据子组件的总长度来设置ListView的长度
    padding: const EdgeInsets.all(20.0),
    children: <Widget>[
      const Text('I\'m dedicating every day to you'),
      const Text('Domestic life was never quite my style'),
      const Text('When you smile, you knock me out, I fall apart'),
      const Text('And I thought I was so smart'),
    ],
  );

  // 2. ListView.builder适合列表项比较多（或者无限）的情况，因为只有当子组件真正显示的时候才会被创建，
  // 也就说通过该构造函数创建的ListView是支持基于Sliver的懒加载模型的
  /*
  ListView.builder({
    // ListView公共参数已省略  
    ...
    // 它是列表项的构建器，类型为IndexedWidgetBuilder，返回值为一个widget
    // 当列表滚动到具体的index位置时，会调用该构建器构建列表项
    @required IndexedWidgetBuilder itemBuilder,

    // 列表项的数量，如果为null，则为无限列表
    int itemCount,
    ...
  })
   */
  final Widget _listView2 = ListView.builder(
    itemCount: 100,
    itemExtent: 50.0, // 强制高度为50.0
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('$index'),
      );
    },
  );

  // 3. ListView.separated 可以在生成的列表项之间添加一个分割组件，
  // 它比ListView.builder多了一个separatorBuilder参数，该参数是一个分割组件生成器
  final Widget _listView3 = ListView.separated(
    itemCount: 100,
    itemBuilder: (context, index) {
      return ListTile(title: Text('$index'));
    },
    separatorBuilder: (context, index) {
      return index % 2 == 0
          ? Divider(color: Colors.blueAccent)
          : Divider(color: Colors.greenAccent);
    },
  );
}

// 实现：无限加载列表
class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  // 表尾标记
  static const loadingTag = '##loading##';
  var _words = <String>[loadingTag];

  // 检索数据
  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      _words.insertAll(
        _words.length - 1,
        // 每次生成20个单词
        generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
      );

      setState(() {
        // //重新构建列表
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(title: Text('英文单词')),
        Expanded(child: initListView()),
      ],
    );
  }

  Widget initListView() {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        // 如果到表尾
        if (_words[index] == loadingTag) {
          // 不足100条，继续获取数据
          if (_words.length - 1 < 100) {
            _retrieveData();

            // 加载时像是loading...
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            // 已经加载了100条数据，不再获取数据
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Text('没有更多了', style: TextStyle(color: Colors.grey)),
            );
          }
        }
        // 显示单词列表
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }
}
