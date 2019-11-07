import 'package:flutter/material.dart';

// 进度指示器
class ProgressIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('进度指示器'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 1. 线性、条状的进度条
              LinearProgressIndicator(
                backgroundColor: Colors.grey[200], // 指示器的背景色
                valueColor: AlwaysStoppedAnimation(Colors.blue), // 指示器的进度条颜色
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.cyan),
                value: 0.5,
              ),

              // 2. 圆形进度条
              CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.cyan),
                value: .5,
              ),

              // 3. 自定义尺寸
              SizedBox(
                height: 3.0, // 线性进度条高度指定为3
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .6,
                ),
              ),

              // 圆形进度条直径指定为100
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .7,
                ),
              ),

              // 4. 进度色动画
              RaisedButton(
                padding: EdgeInsets.all(15.0),
                child: Text('进度色动画'),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProgressValueColorAnimation()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressValueColorAnimation extends StatefulWidget {
  @override
  _ProgressValueColorAnimationState createState() =>
      _ProgressValueColorAnimationState();
}

class _ProgressValueColorAnimationState
    extends State<ProgressValueColorAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animControlelr;

  @override
  void initState() {
    _animControlelr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _animControlelr.forward();
    _animControlelr.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    _animControlelr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('进度色动画'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                // 从灰色变蓝色
                valueColor: ColorTween(
                  begin: Colors.grey,
                  end: Colors.blue,
                ).animate(_animControlelr),
                value: _animControlelr.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
