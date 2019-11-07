import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 手势识别
class GestureTestRoute extends StatefulWidget {
  @override
  _GestureTestRouteState createState() => _GestureTestRouteState();
}

class _GestureTestRouteState extends State<GestureTestRoute> {
  String _operation = "No Gesture detected!"; // 保存事件名

  double _top = 0.0; // 距顶部的偏移
  double _left = 0.0; // 距左边的偏移

  double _width = 200.0; // 通过修改图片宽度来达到缩放效果

  TapGestureRecognizer _tapGes = TapGestureRecognizer();
  bool _toggle = false; // 变色开关

  double _top1 = 0.0;
  double _left1 = 0.0;

  @override
  void dispose() {
    // 用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blueAccent),
      child: Scaffold(
        appBar: AppBar(title: Text('手势识别')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _tap(),
              _drag(),
              _scale(),
              _gestureForRichText(),
              _bothDirectionOfDrag(),
            ],
          ),
        ),
      ),
    );
  }

  // GestureDetector
  // 单击、双击、长按
  Widget _tap() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        width: 200.0,
        height: 100.0,
        child: Text(
          _operation,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: () => updateText('单击'),
      onDoubleTap: () => updateText('双击'),
      onLongPress: () => updateText('长按'),
    );
  }

  void updateText(String text) {
    setState(() {
      _operation = text;
    });
  }

  // 拖动、滑动
  Widget _drag() {
    return Container(
      width: 200.0,
      height: 100.0,
      color: Colors.red,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: CircleAvatar(child: Text('A')),
              // 手指按下时会触发此回调
              onPanDown: (details) {
                // 打印手指按下的位置(相对于屏幕)
                print('用户手指按下：${details.globalPosition}');
              },
              // 手指滑动时会触发此回调
              onPanUpdate: (details) {
                // 用户手指滑动时，更新偏移，重新构建
                setState(() {
                  _left += details.delta.dx;
                  _top += details.delta.dy;
                });
              },
              onPanEnd: (details) {
                // 打印滑动结束时在x、y轴上的速度
                print(details.velocity);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 缩放
  Widget _scale() {
    return GestureDetector(
      // 指定宽度，高度自适应
      child: Image.asset('images/scale.png', width: _width),
      onScaleUpdate: (details) {
        print(details.scale);
        setState(() {
          // 缩放倍数在0.8到10倍之间
          _width = 200 * details.scale.clamp(.8, 10.0);
        });
      },
    );
  }

  // MARK: - GestureRecognizer
  Widget _gestureForRichText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '你好世界'),
          TextSpan(
            text: '点我变色',
            style: TextStyle(
              fontSize: 30.0,
              color: _toggle ? Colors.blue : Colors.red,
            ),
            recognizer: _tapGes
              ..onTap = () {
                setState(() {
                  _toggle = !_toggle;
                });
              },
          ),
          TextSpan(text: '你好世界'),
        ],
      ),
    );
  }

  // MARK: - 手势竞争和冲突
  Widget _bothDirectionOfDrag() {
    return Container(
      width: 200.0,
      height: 100.0,
      color: Colors.red,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: _top1,
            left: _left1,
            child: GestureDetector(
              child: CircleAvatar(child: Text('A')),
              // 垂直方向拖动事件
              onVerticalDragUpdate: (details) {
                setState(() {
                  _top1 += details.delta.dy;
                });
              },

              // 水平方向拖动事件
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _left1 += details.delta.dx;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
