import 'package:flutter/material.dart';

class Product {
  final String title; // 商品标题
  final String description; // 商品描述

  Product(this.title, this.description);
}

void main() {
  runApp(MaterialApp(
    title: '导航的数据传递和接受',
    home: ProductList(products: List.generate(20, (index) => Product('头牌 $index', '一个多才多艺的小姐，编号：$index'))),
  ));
}

class ProductList extends StatelessWidget {

  final List<Product> products;

  ProductList({Key key, @required this.products}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('怡红院'),),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return ListTile(
            leading: Icon(Icons.account_box),
            title: Text(product.title),
            onTap: () { _pushToDetailPage(context, product); },
          );
        },
      ),
    );
  }

  /*跳转详情页*/
  _pushToDetailPage(BuildContext context, Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(product: product,)
      )
    );

    // Toast
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('$result'),
          duration: Duration(milliseconds: 750),
        )
    );
  }
}

class ProductDetail extends StatelessWidget {

  final Product product;

  ProductDetail({Key key, @required this.product}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(product.description),
            RaisedButton(
              child: Text('选择'),
              onPressed: () {
                Navigator.pop(context, '公子有眼光!');
              },
            )
          ],
        ),
      ),
    );
  }
}
