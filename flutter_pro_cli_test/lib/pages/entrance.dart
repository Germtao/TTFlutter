import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter_pro_cli_test/router.dart';

import 'package:flutter_pro_cli_test/pages/search_page/custom_delegate.dart';
import 'package:flutter_pro_cli_test/widgets/menu_draw.dart';

/// eum 类型
enum UniLinksType {
  /// string link
  string,
}

/// 项目页面入口文件
class Entrance extends StatefulWidget {
  /// 页面索引位置
  final int indexValue;

  const Entrance({Key key, this.indexValue}) : super(key: key);

  @override
  _EntranceState createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  UniLinksType _type = UniLinksType.string;
  StreamSubscription _subscription;
  Router router = Router();

  ///  初始化Scheme只使用了String类型的路由跳转
  ///  所以只有一个有需求可以使用[initPlatformStateForUriUniLinks]
  Future<void> initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    }
  }

  /// 使用[String]链接实现
  Future<void> initPlatformStateForStringUniLinks() async {
    String initialLink;

    // 平台消息可能会失败，因此我们使用try / catch PlatformException
    try {
      initialLink = await getInitialLink();
      redirect(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }

    // 将侦听器附加到链接流
    _subscription = getLinksStream().listen((String link) {
      if (!mounted || link == null) return;

      // 跳转到指定页面
      redirect(link);
    }, onError: (Object error) {
      if (!mounted) return;
    });
  }

  /// 跳转页面
  void redirect(String link) {
    if (link == null) {
      return;
    }

    int indexNum = router.open(context, link);
    if (indexNum > -1 && _controller.index != indexNum) {
      _controller.animateTo(indexNum);
    }
  }

  @override
  void initState() {
    super.initState();
    // scheme 初始化，保证有上下文，需要跳转页面
    initPlatformState();

    _controller = TabController(vsync: this, length: 3);
    if (widget.indexValue != null) {
      _controller.animateTo(widget.indexValue);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    if (_subscription != null) _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two You'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPageCustomDelegate(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              icon: Icon(Icons.view_list),
              text: '推荐',
            ),
            Tab(
              icon: Icon(Icons.favorite),
              text: '关注',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: '我',
            )
          ],
        ),
      ),
      drawer: MenuDraw(redirect),
      body: TabBarView(
        controller: _controller,
        children: [
          router.getPageByRouter('homepage'),
          Icon(Icons.directions_transit),
          router.getPageByRouter('userpage'),
        ],
      ),
    );
  }
}
