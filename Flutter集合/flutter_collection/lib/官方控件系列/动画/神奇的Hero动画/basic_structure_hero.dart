import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

/// [Hero Widget]其实是利用了补件动画
/// 两个尽量相似的[Hero]之间，使用同一个[tag name]来进行[animation]
/// 所以分为[源hero]与[目标hero]
/// 通过导入[scheduler]包中的[timeDilation]能够修改变化速度
/// 在[源Hero]的[build]函数中设定[timeDilation]值即可
class SourceHeroPage extends StatefulWidget {
  @override
  _SourceHeroPageState createState() => _SourceHeroPageState();
}

class _SourceHeroPageState extends State<SourceHeroPage> {
  Hero _sourceHero = Hero(
    tag: 'hero tag',
    child: Container(
      width: 100.0,
      height: 100.0,
      color: Colors.lightBlue,
    ),
  );

  @override
  Widget build(BuildContext context) {
    timeDilation = 5.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('源Hero Page'),
      ),
      body: Center(
        child: GestureDetector(
          child: _sourceHero,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TargetHeroPage()),
          ),
        ),
      ),
    );
  }
}

class TargetHeroPage extends StatefulWidget {
  @override
  _TargetHeroPageState createState() => _TargetHeroPageState();
}

class _TargetHeroPageState extends State<TargetHeroPage> {
  Hero _targetHero = Hero(
    tag: 'hero tag',
    child: Container(
      // width: 400.0,
      height: 100.0,
      color: Colors.blue,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('目标Hero Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: _targetHero,
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
