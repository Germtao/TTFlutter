import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter_pro_cli_test/router.dart';

/// eum 类型
enum UniLinksType {
  /// string link
  string,
}

/// 项目页面入口文件
class Entrance extends StatefulWidget {
  @override
  _EntranceState createState() => _EntranceState();
}

class _EntranceState extends State<Entrance> {
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
      if (initialLink != null) {
        // 跳转到指定页面
        router.push(context, initialLink);
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }

    // 将侦听器附加到链接流
    _subscription = getLinksStream().listen((String link) {
      if (!mounted || link == null) return;

      // 跳转到指定页面
      router.push(context, link);
    }, onError: (Object error) {
      if (!mounted) return;
    });
  }

  @override
  void initState() {
    super.initState();
    // scheme 初始化，保证有上下文，需要跳转页面
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Text('Hello Flutter scaffold.'),
          )
        ],
      ),
    );
  }
}
