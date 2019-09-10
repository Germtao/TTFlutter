import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Widget',
      home: Scaffold(
        appBar: new AppBar(title: new Text('卡片布局'),),
        body: new Center(
          child: MyCard(),
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new MyListTile(
            title: '江西省南昌市新建区',
            subTitle: '紫云府13栋',
          ),
          new MyListTile(
            title: '浙江省杭州市余杭区',
            subTitle: '翁梅新苑',
          ),
        ],
      ),
    );
  }
}

class MyListTile extends StatelessWidget {

  final String title;
  final String subTitle;

  MyListTile({Key key, this.title, this.subTitle}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: new Text(title, style: TextStyle(fontWeight: FontWeight.w500),),
      subtitle: new Text(subTitle),
      leading: new Icon(Icons.account_box, color: Colors.lightBlue,),
    );
  }
}