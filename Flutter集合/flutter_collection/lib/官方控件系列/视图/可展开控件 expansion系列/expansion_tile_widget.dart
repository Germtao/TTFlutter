import 'package:flutter/material.dart';

/// 最基础的展开小部件[expansion tile]
/// 用法很简单，将需要被展开的部件放在children中即可
/// 其他用法和[list tile]很相似
/// 当[expansion tile] 被展开时，我们可以看到[background color]
/// 会进行一个[transition]动画进行过渡
/// [expansion tile]还有一个[trailing]属性，代表右边的小箭头
/// 可以自行替换
/// [initiallyExpanded]代表最初的状态是否被展开
/// 默认为[false]，也就是不展开
///
/// 当一个list view中由多个expansion tile的时候
/// 需要给每一个[expansion tile]指定唯一的[PageStorageKey]
/// 以保证在滑动的过程中，能够记住expansion tile的开关状态
class ExpansionTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expansion Tile Widget'),
      ),
      body: Center(
        child: ExpansionTile(
          title: Text('Expansion Tile'),
          leading: Icon(Icons.ac_unit),
          backgroundColor: Colors.white12,
          children: <Widget>[
            ListTile(
              title: Text('list tile'),
              subtitle: Text('subtitle'),
            )
          ],
          initiallyExpanded: true,
        ),
      ),
    );
  }
}
