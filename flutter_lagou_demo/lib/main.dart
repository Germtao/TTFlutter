import 'package:flutter/material.dart';
import 'package:flutter_lagou_demo/pages/home_page_widget.dart';
import 'test/provider/pages/provider_name_game.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'pages/test_stateful_widget.dart';
import 'pages/home_page.dart';

import 'test/name_game.dart';

import 'package:redux/redux.dart';
import 'package:flutter_lagou_demo/test/redux/pages/redux_name_game.dart';
import 'package:flutter_lagou_demo/test/redux/states/name_states.dart';

void main() {
  runApp(MyApp());

//  final store = Store<NameStates>(reducer, initialState: NameStates.initState());
//  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {

//  final Store<NameStates> store;

//  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
//    return StoreProvider(
//      store: store,
//      child: MaterialApp(
//        title: 'Two You', // app 的title信息
//        theme: ThemeData(
//          primarySwatch: Colors.blue, // 页面的主题颜色
//          visualDensity: VisualDensity.adaptivePlatformDensity,
//        ),
//        home: Scaffold(
//          appBar: AppBar(
//            title: Text('Two You'),
//          ),
//          body: Center(
////          child: NameGame(),
//            child: ReduxNameGame(store: store),
//          ),
//        ),
//      ),
//    );
    return MaterialApp(
      title: 'Two You', // app 的title信息
      theme: ThemeData(
        primarySwatch: Colors.blue, // 页面的主题颜色
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Two You'),
        ),
        body: Center(
          child: ProviderNameGame(),
        ),
      ),
    );
  }
}
