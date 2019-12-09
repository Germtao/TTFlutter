import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomWidgetTestRoute extends StatefulWidget {
  @override
  _CustomWidgetTestRouteState createState() => _CustomWidgetTestRouteState();
}

class _CustomWidgetTestRouteState extends State<CustomWidgetTestRoute> {
  double _turns = .0;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('自定义控件'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              GradientButton(
                colors: [Colors.orange, Colors.red],
                height: 50.0,
                child: Text('按钮 1'),
                onPressed: () => print('点击按钮 1'),
              ),
              GradientButton(
                colors: [Colors.lightGreen, Colors.grey[700]],
                height: 50.0,
                child: Text('按钮 2'),
                onPressed: () => print('点击按钮 2'),
              ),
              GradientButton(
                colors: [Colors.lightBlue[200], Colors.blueAccent],
                height: 50.0,
                child: Text('按钮 3'),
                onPressed: () => print('点击按钮 3'),
              ),
              TurnBox(
                turns: _turns,
                speed: 500,
                child: Icon(Icons.refresh, size: 50.0),
              ),
              TurnBox(
                turns: _turns,
                speed: 1000,
                child: Icon(Icons.refresh, size: 150.0),
              ),
              RaisedButton(
                child: Text('顺时针旋转1/5圈'),
                onPressed: () {
                  setState(() {
                    _turns += .2;
                  });
                },
              ),
              RaisedButton(
                child: Text('逆时针旋转1/5圈'),
                onPressed: () {
                  setState(() {
                    _turns -= .2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 组合控件
// 1. 渐变按钮
class GradientButton extends StatelessWidget {
  GradientButton({
    this.colors,
    this.width,
    this.height,
    this.onPressed,
    this.radius,
    @required this.child,
  });

  final List<Color> colors; // 渐变色数组

  final double width; // 按钮宽
  final double height; // 按钮高

  final Widget child;
  final BorderRadius radius;

  final GestureTapCallback onPressed; // 点击回调

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    // 确保colors数组不空
    List<Color> _colors = colors ??
        [
          themeData.primaryColor,
          themeData.primaryColorDark ?? themeData.primaryColor
        ];

    return DecoratedBox(
      // 支持背景色渐变和圆角
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _colors),
        borderRadius: radius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          // 手指按下有涟漪效果
          splashColor: _colors.last,
          highlightColor: Colors.transparent,
          borderRadius: radius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 2. TurnBox
class TurnBox extends StatefulWidget {
  TurnBox({
    Key key,
    this.turns = .0,
    this.speed = 200,
    this.child,
  }) : super(key: key);

  final double turns; // 旋转的“圈”数,一圈为360度，如0.25圈即90度
  final int speed; // 过渡动画执行的总时长
  final Widget child;

  @override
  _TurnBoxState createState() => _TurnBoxState();
}

class _TurnBoxState extends State<TurnBox> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: -double.infinity,
      upperBound: double.infinity,
      vsync: this,
    );
    _controller.value = widget.turns;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(TurnBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 旋转角度发生变化时执行过渡动画
    if (oldWidget.turns != widget.turns) {
      _controller.animateTo(
        widget.turns,
        duration: Duration(milliseconds: widget.speed ?? 200),
        curve: Curves.easeOut,
      );
    }
  }
}
