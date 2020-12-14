import 'package:flutter/material.dart';

class AnimDemoPage extends StatefulWidget {
  @override
  _AnimDemoPageState createState() => _AnimDemoPageState();
}

class _AnimDemoPageState extends State<AnimDemoPage> with SingleTickerProviderStateMixin {
  AnimationController controller1;

  Animation animation1;
  Animation animation2;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation1 = Tween(begin: 0.0, end: 200.0).animate(controller1);
    animation1.addListener(() {
      setState(() {});
    });

    animation2 = Tween(begin: 0.0, end: 1.0).animate(controller1);

    controller1.repeat();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimDemoPage'),
      ),
      body: RotationTransition(
        turns: animation2,
        child: Container(
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              color: Colors.redAccent,
              child: CustomPaint(
                // 直接使用值做动画
                foregroundPainter: AnimationPainter(animation1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimationPainter extends CustomPainter {
  Paint _paint = Paint();

  Animation animation;

  AnimationPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = Colors.redAccent;
    _paint.strokeWidth = 4;
    _paint.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(100, 100), animation.value * 1.5, _paint);
  }

  @override
  bool shouldRepaint(AnimationPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(AnimationPainter oldDelegate) => false;
}
