import 'package:flutter/material.dart';

/// [onRecorder]函数中，
/// [oldIndex]代表移动前[item]的序号
/// [newIndex]代表移动后[item]的序号
/// 由于在向后移动的时候，[newIndex]会因为之前的占位
/// 而多出一个，所以需要处理一下
class ReorderableListViewDemo extends StatefulWidget {
  @override
  _ReorderableListViewDemoState createState() => _ReorderableListViewDemoState();
}

class _ReorderableListViewDemoState extends State<ReorderableListViewDemo> {
  List<String> names = [
    "LeBron James",
    "Kevin Durant",
    "Anthony Davis",
    "James Harden",
    "Stephen Curry",
    "Giannis Antetokounmopo",
    "Joel Embiid",
    "Russell Westbrook",
    "Paul George",
    "Kawhi Leonard",
    "Jeremy Shuhow Lin"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
        header: AppBar(
          title: Text('Reorderable List View'),
        ),
        children: names.map(_buildCard).toList(),
        onReorder: _onReorder,
      ),
    );
  }

  Widget _buildCard(String name) {
    return SizedBox(
      key: ObjectKey(name),
      height: 200.0,
      child: Card(
        color: Colors.lightBlueAccent.withOpacity(0.4),
        child: Center(
          child: Text(
            '$name',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex = newIndex - 1;
    }

    var name = names.removeAt(oldIndex);
    names.insert(newIndex, name);
    setState(() {});
  }
}
