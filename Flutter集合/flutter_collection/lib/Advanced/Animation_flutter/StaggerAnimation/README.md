# 交织动画 (Stagger Animation)

![交织动画]()

有些时候我们可能会需要一些复杂的动画，这些动画可能由一个动画序列或重叠的动画组成。

比如：有一个柱状图，需要在高度增长的同时改变颜色，等到增长到最大高度后，我们需要在X轴上平移一段距离。可以发现上述场景在不同阶段包含了多种动画，要实现这种效果，使用交织动画 `Stagger Animation` 会非常简单。交织动画需要注意以下几点：

1. 要创建交织动画，需要使用多个动画对象（`Animation`）

2. 一个 `AnimationController` 控制所有的动画对象

3. 给每一个动画对象指定时间间隔（`Interval`）

所有动画都由同一个 `AnimationController` 驱动，无论动画需要持续多长时间，控制器的值必须在0.0到1.0之间，而每个动画的间隔（`Interval`）也必须介于0.0和1.0之间。对于在间隔中设置动画的每个属性，需要分别创建一个 `Tween` 用于指定该属性的开始值和结束值。也就是说0.0到1.0代表整个动画过程，我们可以给不同动画指定不同的起始点和终止点来决定它们的开始时间和终止时间。

## 示例

下面我们看一个例子，实现一个柱状图增长的动画：

1. 开始时高度从0增长到300像素，同时颜色由绿色渐变为红色；这个过程占据整个动画时间的60%

2. 度增长到300后，开始沿X轴向右平移100像素；这个过程占用整个动画时间的40%

我们将执行动画的Widget分离出来：

```
class StaggerAnimation extends StatefulWidget {
  StaggerAnimation({Key key, this.controller}) : super(key: key);

  final Animation<double> controller;

  @override
  _StaggerAnimationState createState() => _StaggerAnimationState();
}

class _StaggerAnimationState extends State<StaggerAnimation> {
  Animation<double> _height;
  Animation<EdgeInsets> _padding;
  Animation<Color> _color;

  @override
  void initState() {
    super.initState();
    // 高度动画
    _height = Tween<double>(
      begin: .0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.0, 0.6, curve: Curves.ease), // 间隔，前60%的动画时间
      ),
    );

    // 颜色动画
    _color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.0, 0.6, curve: Curves.ease), // 间隔，前60%的动画时间
      ),
    );

    // 平移动画
    _padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: .0),
      end: EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.6, 1.0, curve: Curves.ease), // 间隔，后40%的动画时间
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: _padding.value,
      child: Container(
        color: _color.value,
        width: 50.0,
        height: _height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.controller,
    );
  }
}
```

`StaggerAnimation` 中定义了三个动画，分别是对 `Container` 的 `height`、`color`、`padding` 属性设置的动画，然后通过 `Interval` 来为每个动画指定在整个动画过程中的起始点和终点。下面来实现启动动画的路由：

```
class StaggerAnimationTestRoute extends StatefulWidget {
  @override
  _StaggerAnimationTestRouteState createState() =>
      _StaggerAnimationTestRouteState();
}

class _StaggerAnimationTestRouteState extends State<StaggerAnimationTestRoute>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  // 播放动画
  Future<Null> _playAnimation() async {
    try {
      // 先正向执行动画
      await _controller.forward().orCancel;
      // 再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // 动画被取消了, 可能是因为被释放了
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('交织动画')),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _playAnimation();
          },
          child: Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              // 调用我们定义的交织动画Widget
              child: StaggerAnimation(
                controller: _controller,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```