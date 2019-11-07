import 'package:flutter/material.dart';
import 'package:flutter_collection/GettingStarted/功能型控件/Provider(跨控件状态共享)/change_notifier_provider.dart';
import 'package:flutter_collection/GettingStarted/功能型控件/Provider(跨控件状态共享)/购物车示例/cart_model.dart';

class CartProviderRoute extends StatefulWidget {
  @override
  _CartProviderRouteState createState() => _CartProviderRouteState();
}

class _CartProviderRouteState extends State<CartProviderRoute> {
  final Widget provider = ChangeNotifierProvider<CartModel>(
    data: CartModel(),
    child: Builder(builder: (context) {
      return Column(
        children: <Widget>[
          Builder(
            builder: (context) {
              var cart = ChangeNotifierProvider.of<CartModel>(context);
              return Text(
                '总价：${cart.totalPrice}',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              );
            },
          ),
          Builder(
            builder: (context) {
              print("RaisedButton build"); //在后面优化部分会用到
              var cart = ChangeNotifierProvider.of<CartModel>(context);
              return RaisedButton(
                child: Text('添加商品'),
                onPressed: () {
                  // 给购物车中添加商品，添加后总价会更新
                  cart.add(Item(20.0, 1));
                },
              );
            },
          ),
        ],
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('跨控件状态管理(Provider)'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: provider,
      ),
    );
  }
}
