# 通用 `切换动画` 控件 （AnimatedSwitcher）

实际开发中，我们经常会遇到切换UI元素的场景，比如Tab切换、路由切换。为了增强用户体验，通常在切换时都会指定一个动画，以使切换过程显得平滑。`Flutter SDK` 控件库中已经提供了一些常用的切换控件，如 `PageView`、`TabView`等。但是，这些控件并不能覆盖全部的需求场景，为此，Flutter SDK中提供了一个 `AnimatedSwitcher` 控件，它定义了一种通用的UI切换抽象。

## AnimatedSwitcher

`AnimatedSwitcher` 可以同时对其新、旧子元素添加显示、隐藏动画。也就是说在 `AnimatedSwitcher` 的子元素发生变化时，会对其旧元素和新元素。先看看 `AnimatedSwitcher` 的定义：

```
const AnimatedSwitcher({
  Key key,
  this.child,
  @required this.duration, // 新child显示动画时长
  this.reverseDuration, // 旧child隐藏的动画时长
  this.switchInCurve = Curves.linear, // 新child显示的动画曲线
  this.switchOutCurve = Curves.linear,// 旧child隐藏的动画曲线
  this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder, // 动画构建器
  this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder, //布局构建器
})
```

当 `AnimatedSwitcher` 的 `child` 发生变化时（类型或Key不同），**旧child** 会执行隐藏动画，**新child** 会执行执行显示动画。究竟执行何种动画效果则由 `transitionBuilder` 参数决定，该参数接受一个 `AnimatedSwitcherTransitionBuilder` 类型的 `builder`，定义如下：

`typedef AnimatedSwitcherTransitionBuilder = Widget Function(Widget child, Animation<double> animation);`

该 `builder` 在 `AnimatedSwitcher` 的 `child` 切换时会分别对新、旧child绑定动画：

1. 对旧child，绑定的动画会反向执行（reverse）

2. 新child，绑定的动画会正向指向（forward）

这样一下，便实现了对新、旧child的动画绑定。`AnimatedSwitcher` 的默认值是 `AnimatedSwitcher.defaultTransitionBuilder`：

```
Widget defaultTransitionBuilder(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}
```

可以看到，返回了 `FadeTransition` 对象，也就是说默认情况，`AnimatedSwitcher` 会对新旧child执行 **渐隐** 和 **渐显** 动画。

## 示例

下面我们看一个🌰：实现一个计数器，然后再每一次自增的过程中，旧数字执行缩小动画隐藏，新数字执行放大动画显示，代码如下：

```
class AnimatedSwitcherCounterRoute extends StatefulWidget {
  @override
  _AnimatedSwitcherCounterRouteState createState() =>
      _AnimatedSwitcherCounterRouteState();
}

class _AnimatedSwitcherCounterRouteState
    extends State<AnimatedSwitcherCounterRoute> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('通用切换动画控件')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                // 执行缩放动画
                return ScaleTransition(
                  child: child,
                  scale: animation,
                );
              },
              child: Text(
                '$_count',
                // 显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                key: ValueKey<int>(_count),
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            RaisedButton(
              child: Text('+1'),
              onPressed: () {
                setState(() => _count += 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

当点击 `+1` 按钮时，原先的数字会逐渐缩小直至隐藏，而新数字会逐渐放大。运行效果如下图：

![动画效果](https://github.com/Germtao/TTFlutter/blob/master/Flutter%E9%9B%86%E5%90%88/flutter_collection/lib/Advanced/Animation_flutter/AnimatedSwitcher/switcher_anim.gif)

> 注：`AnimatedSwitcher` 的新旧child，如果类型相同，则 `Key` 必须不相等。

## AnimatedSwitcher 实现原理

要想实现新旧child切换动画，只需要明确两个问题：

1. 动画执行的时机？

2. 如何对新旧child执行动画？

从 `AnimatedSwitcher` 的使用方式可以看出，当 `child` 发生变化时（**子widget的key和类型不同时相等则认为发生变化**），则重新会重新执行build，然后动画开始执行。

我们可以通过继承 `StatefulWidget` 来实现 `AnimatedSwitcher`，具体做法是在 `didUpdateWidget` 回调中判断其新旧child是否发生变化，如果发生变化，则对旧child执行反向退场（reverse）动画，对新child执行正向（forward）入场动画即可。下面是 `AnimatedSwitcher` 实现的部分核心伪代码：

```
Widget _widget; //
void didUpdateWidget(AnimatedSwitcher oldWidget) {
  super.didUpdateWidget(oldWidget);
  // 检查新旧child是否发生变化(key或类型同时相等则返回true，认为没变化)
  if (Widget.canUpdate(widget.child, oldWidget.child)) {
    // child没变化
    _childNumber += 1;
    _addEntryForNewChild(animate: true);
  } else {
    // child发生了变化，构建一个Stack来分别给新旧child执行动画
   _widget= Stack(
      alignment: Alignment.center,
      children:[
        //旧child应用FadeTransition
        FadeTransition(
         opacity: _controllerOldAnimation,
         child : oldWidget.child,
        ),
        //新child应用FadeTransition
        FadeTransition(
         opacity: _controllerNewAnimation,
         child : widget.child,
        ),
      ]
    );
    // 给旧child执行反向退场动画
    _controllerOldAnimation.reverse();
    // 给新child执行正向入场动画
    _controllerNewAnimation.forward();
  }
}

// build方法
Widget build(BuildContext context){
  return _widget;
}
```

上面伪代码展示了 `AnimatedSwitcher` 实现的核心逻辑，当然 `AnimatedSwitcher` 真正的实现比这个复杂，它可以自定义进退场过渡动画以及执行动画时的布局等。

另外，`Flutter SDK` 中还提供了一个 `AnimatedCrossFade` 控件，它也可以切换两个子元素，切换过程执行渐隐渐显的动画，和 `AnimatedSwitcher` 不同的是 `AnimatedCrossFade` 是针对两个子元素，而 `AnimatedSwitcher` 是在一个子元素的新旧值之间切换。

