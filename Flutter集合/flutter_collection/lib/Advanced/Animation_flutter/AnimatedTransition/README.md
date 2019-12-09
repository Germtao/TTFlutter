# 动画过渡控件

为了表述方便，本书约定，将在 `Widget` 属性发生变化时会执行过渡动画的控件统称为 **动画过渡控件**，而动画过渡控件最明显的一个特征就是它会在内部自管理 `AnimationController`。

为了方便使用者可以自定义动画的曲线、执行时长、方向等，在前面介绍过的动画封装方法中，通常都需要使用者自己提供一个AnimationController对象来自定义这些属性值。但是，如此一来，使用者就必须得手动管理AnimationController，这又会增加使用的复杂性。因此，如果也能将AnimationController进行封装，则会大大提高动画组件的易用性。

## 自定义动画过渡组件

我们要实现一个 `AnimatedDecoratedBox`，它可以在 `decoration` 属性发生变化时，从旧状态变成新状态的过程可以执行一个过渡动画。根据前面所学的知识，我们实现了一个 `AnimatedDecoratedBox1` 控件：

```
class AnimatedDecoratedBox1 extends StatefulWidget {
  AnimatedDecoratedBox1({
    Key key,
    @required this.decoration,
    this.child,
    this.curve = Curves.linear,
    @required this.duration,
    this.reverseDuration,
  });

  final BoxDecoration decoration;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration reverseDuration;

  @override
  _AnimatedDecoratedBox1State createState() => _AnimatedDecoratedBox1State();
}

class _AnimatedDecoratedBox1State extends State<AnimatedDecoratedBox1>
    with SingleTickerProviderStateMixin {
  @protected
  AnimationController get controller => _controller;
  AnimationController _controller;

  Animation<double> get animation => _animation;
  Animation<double> _animation;

  DecorationTween _tween;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return DecoratedBox(
          decoration: _tween.animate(_animation).value,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
    _tween = DecorationTween(begin: widget.decoration);
    _updateCurve();
  }

  void _updateCurve() {
    if (widget.curve != null) {
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      );
    } else {
      _animation = _controller;
    }
  }

  @override
  void didUpdateWidget(AnimatedDecoratedBox1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.curve != oldWidget.curve) {
      _updateCurve();
    }
    _controller.duration = widget.duration;
    _controller.reverseDuration = widget.reverseDuration;
    // 正在执行过渡动画
    if (widget.decoration != (_tween.end ?? _tween.begin)) {
      _tween
        ..begin = _tween.evaluate(_animation)
        ..end = widget.decoration;
      _controller
        ..value = 0.0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

下面使用`AnimatedDecoratedBox1`来实现按钮点击后背景色从蓝色过渡到红色的效果：

```
Color _decorationColor = Colors.blue;
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
```

上面的代码虽然实现了期望的功能，但是代码却比较复杂。稍加思考后就可以发现，`AnimationController`的管理以及`Tween`更新部分的代码都是可以抽象出来的，如果这些通用逻辑封装成基类，那么要实现动画过渡控件只需要继承这些基类，然后定制自身不同的代码（比如动画每一帧的构建方法）即可，这样将会简化代码。

为了方便开发者来实现动画过渡控件的封装，`Flutter`提供了一个`ImplicitlyAnimatedWidget`抽象类，它继承自`StatefulWidget`，同时提供了一个对应的`ImplicitlyAnimatedWidgetState`类，`AnimationController`的管理就在`ImplicitlyAnimatedWidgetState`类中。开发者如果要封装动画，只需要分别继承`ImplicitlyAnimatedWidget`和`ImplicitlyAnimatedWidgetState`类即可，下面来演示一下具体如何实现。

只需要分两步实现：

1. 继承`ImplicitlyAnimatedWidget`类

```
class AnimatedDecoratedBox extends ImplicitlyAnimatedWidget {
  AnimatedDecoratedBox({
    Key key,
    @required this.decoration,
    this.child,
    Curve curve = Curves.linear, // 动画曲线
    @required Duration duration, // 正向动画执行时长
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );

  final BoxDecoration decoration;
  final Widget child;

  @override
  _AnimatedDecoratedBoxState createState() => _AnimatedDecoratedBoxState();
}
```

其中`curve`、`duration`两个属性在`ImplicitlyAnimatedWidget`中已定义。可以看到`AnimatedDecoratedBox`类和普通继承自`StatefulWidget`的类没有什么不同。

2. `State`类继承自`AnimatedWidgetBaseState`（该类继承自`ImplicitlyAnimatedWidgetState`类）

```
class _AnimatedDecoratedBoxState
    extends AnimatedWidgetBaseState<AnimatedDecoratedBox> {
  DecorationTween _decoration; // 定义一个tween

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration.evaluate(animation), // 计算每一帧的 decoration 状态
      child: widget.child,
    );
  }

  @override
  void forEachTween(visitor) {
    // 在需要更新Tween时，基类会调用此方法
    _decoration = visitor(_decoration, widget.decoration,
        (value) => DecorationTween(begin: value));
  }
}
```

可以看到实现了`build`和`forEachTween`两个方法。在动画执行过程中，每一帧都会调用`build`方法（调用逻辑在`ImplicitlyAnimatedWidgetState`中），所以在`build`方法中需要构建每一帧的`DecoratedBox`状态，因此得算出每一帧的`decoration`状态，这个可以通过`_decoration.evaluate(animation)`来算出，其中`animation`是`ImplicitlyAnimatedWidgetState`基类中定义的对象，`_decoration`是自定义的一个`DecorationTween`类型的对象，那么现在的问题就是它是在什么时候被赋值的呢？

要回答这个问题，就得搞清楚什么时候需要对`_decoration`赋值。我们知道`_decoration`是一个`Tween`，而`Tween`的主要职责就是定义动画的`起始状态(begin)`和`终止状态(end)`。对于`AnimatedDecoratedBox`来说，`decoration`的终止状态就是用户传给它的值，而起始状态是不确定的，有以下两种情况：

1. `AnimatedDecoratedBox`首次`build`，此时直接将其`decoration`值置为起始状态，即`_decoration`值为`DecorationTween(begin: decoration)`

2. `AnimatedDecoratedBox`的`decoration`更新时，则起始状态为`_decoration.animate(animation)`，即`_decoration`值为`DecorationTween(begin: _decoration.animate(animation)，end:decoration)`

现在`forEachTween`的作用就很明显了，它正是用于来更新`Tween`的初始值的，在上述两种情况下会被调用，而开发者只需重写此方法，并在此方法中更新`Tween`的起始状态值即可。而一些更新的逻辑被屏蔽在了`visitor`回调，我们只需要调用它并给它传递正确的参数即可，`visitor`方法签名如下：

```
Tween visitor(
  Tween<dynamic> tween, // 当前的tween，第一次调用为null
  dynamic targetValue, // 终止状态
  TweenConstructor<dynamic> constructor，// Tween构造器，在上述三种情况下会被调用以更新tween
);
```

可以看到，通过继承`ImplicitlyAnimatedWidget`和`ImplicitlyAnimatedWidgetState`类可以快速的实现动画过渡控件的封装，这和纯手工实现相比，代码简化了很多。