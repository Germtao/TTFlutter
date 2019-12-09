import 'package:flutter/material.dart';
import 'animated_transition.dart';

class AnimatedTransitionPageRoute extends StatefulWidget {
  @override
  _AnimatedTransitionPageRouteState createState() =>
      _AnimatedTransitionPageRouteState();
}

class _AnimatedTransitionPageRouteState
    extends State<AnimatedTransitionPageRoute> {
  Color _decorationColor = Colors.blue;

  Duration duration = Duration(milliseconds: 5000);
  double _padding = 10;
  double _left = 0;
  var _align = Alignment.topRight;
  double _height = 100;
  Color _color = Colors.red;
  TextStyle _style = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('动画过渡控件'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                animatedDecoratedBox(),
                animatedDecoratedBox1(),
                animatedPadding(),
                animatedPositioned(),
                animatedAlign(),
                animatedContainer(),
                animatedDefaultTestStyle(),
              ].map((e) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: e,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // 当字体样式发生变化时，子组件中继承了该样式的文本组件会动态过渡到新样式
  Widget animatedDefaultTestStyle() {
    return AnimatedDefaultTextStyle(
      child: GestureDetector(
        child: Text('Hello World'),
        onTap: () {
          setState(() {
            _style = _style == TextStyle(color: Colors.black)
                ? TextStyle(
                    color: Colors.blue,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Colors.blue,
                  )
                : TextStyle(color: Colors.black);
          });
        },
      ),
      style: _style,
      duration: duration,
    );
  }

  // 当Container属性发生变化时会执行过渡动画到新的状态
  Widget animatedContainer() {
    return AnimatedContainer(
      duration: duration,
      height: _height,
      color: _color,
      child: FlatButton(
        onPressed: () {
          setState(() {
            _height = _height == 100 ? 150 : 100;
            _color = _color == Colors.red ? Colors.blue : Colors.red;
          });
        },
        child: Text(
          'AnimatedContainer',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // 当alignment发生变化时会执行过渡动画到新的状态
  Widget animatedAlign() {
    return Container(
      height: 100,
      color: Colors.grey,
      child: AnimatedAlign(
        duration: duration,
        alignment: _align,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _align = _align == Alignment.topRight
                  ? Alignment.center
                  : Alignment.topRight;
            });
          },
          child: Text('AnimatedAlign'),
        ),
      ),
    );
  }

  // 配合Stack一起使用，当定位状态发生变化时会执行过渡动画到新的状态
  Widget animatedPositioned() {
    return SizedBox(
      height: 50,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: duration,
            left: _left,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  _left = _left == 0 ? 100 : 0;
                });
              },
              child: Text('AnimatedPositioned'),
            ),
          ),
        ],
      ),
    );
  }

  // 在padding发生变化时会执行过渡动画到新状态
  Widget animatedPadding() {
    return RaisedButton(
      onPressed: () {
        setState(() {
          _padding = _padding == 10 ? 20 : 10;
        });
      },
      child: AnimatedPadding(
        duration: duration,
        padding: EdgeInsets.all(_padding),
        child: Text('AnimatedPadding'),
      ),
    );
  }

  Widget animatedDecoratedBox1() {
    return AnimatedDecoratedBox1(
      duration:
          Duration(milliseconds: _decorationColor == Colors.red ? 400 : 2000),
      decoration: BoxDecoration(color: _decorationColor),
      child: FlatButton(
        onPressed: () {
          setState(() {
            _decorationColor =
                _decorationColor == Colors.red ? Colors.blue : Colors.red;
          });
        },
        child: Text(
          '点我变色',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget animatedDecoratedBox() {
    return AnimatedDecoratedBox(
      duration:
          Duration(milliseconds: _decorationColor == Colors.red ? 400 : 2000),
      decoration: BoxDecoration(color: _decorationColor),
      child: FlatButton(
        onPressed: () {
          setState(() {
            _decorationColor =
                _decorationColor == Colors.red ? Colors.blue : Colors.red;
          });
        },
        child: Text(
          '点我变色',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
