import 'package:flutter/material.dart';

/// 使用[Dismissible]组件实现右滑删除
/// 它是根据[Key]来删除[ListView]中的某一项的
/// 请注意[ListView.builder]中[itemBuilder: (context, index)]传进的[index]
/// 他不是list中的下标，而是这个组件在当前屏幕上所占的位置
class SwipeToDismissDemo extends StatefulWidget {
  @override
  _SwipeToDismissDemoState createState() => _SwipeToDismissDemoState();
}

class _SwipeToDismissDemoState extends State<SwipeToDismissDemo> {
  List<String> list = List.generate(20, (index) => 'This is number $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('左滑删除ListView中Item'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(list[index]),
            direction: DismissDirection.endToStart,
            child: ListTile(
              title: Text('${list[index]}'),
            ),
            background: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '删除',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              color: Colors.redAccent,
            ),
            onDismissed: (direction) {
              setState(() {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${list[index]}已删除'),
                  duration: Duration(milliseconds: 1500),
                ));
                list.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }
}
