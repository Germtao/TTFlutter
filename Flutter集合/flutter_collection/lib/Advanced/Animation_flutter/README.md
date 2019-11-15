# 动画

## 简介

在任何系统的UI框架中，动画实现的原理都是相同的，即：在一段时间内，快速地多次改变UI外观；由于人眼会产生视觉暂留，所以最终看到的就是一个 `连续` 的动画，这和电影的原理是一样的。

UI的一次改变称为一个动画帧，对应一次屏幕刷新，而决定动画流畅度的一个重要指标就是`帧率FPS（Frame Per Second）`，即每秒的动画帧数。很明显，帧率越高则动画就会越流畅！

一般情况下，对于人眼来说，动画帧率超过 `16FPS`，就比较流畅了，超过 `32FPS` 就会非常的细腻平滑，而超过32FPS，人眼基本上就感受不到差别了。由于动画的每一帧都是要改变UI输出，所以在一个时间段内连续的改变UI输出是比较耗资源的，对设备的软硬件系统要求都较高，所以在UI系统中，动画的平均帧率是重要的性能指标。

### Flutter 中动画抽象

为了方便开发者创建动画，不同的UI系统对动画都进行了一些抽象，主要涉及一下四种角色：

- Animation

- Curve

- Controller

- Tween

#### Animation

- 是一个抽象类，它本身和UI渲染没有任何关系，而它主要的功能是保存动画的插值和状态；其中一个比较常用的Animation类是 `Animation<double>`。

- 是一个在一段时间内依次生成一个 `区间(Tween)` 之间值的类

- 在整个动画执行过程中输出的值可以是线性的、曲线的、一个步进函数或者任何其他曲线函数等等，这由 `Curve` 来决定

- 根据它的控制方式，动画可以正向运行（从起始状态开始，到终止状态结束），也可以反向运行，甚至可以在中间切换方向

- 还可以生成除 `double` 之外的其他类型值，如：`Animation<Color>` 或 `Animation<Size>`。在动画的每一帧中，可以通过它的 `value` 属性获取动画的当前状态值

*动画通知*

可以通过 `Animation` 来监听动画每一帧以及执行状态的变化，Animation有如下两个方法：

1. `addListener()`：它可以用于给Animation添加帧监听器，在每一帧都会被调用。帧监听器中最常见的行为是改变状态后调用 `setState()` 来触发UI重建

2. `addStatusListener()`：它可以给Animation添加“动画状态改变”监听器；动画开始、结束、正向或反向（见AnimationStatus定义）时会调用状态改变的监听器

#### Curve

动画过程可以是匀速的、匀加速的或者先加速后减速等。Flutter中通过 `Curve（曲线）` 来描述动画过程，我们把匀速动画称为线性的 `(Curves.linear)`，而非匀速动画称为非线性的。

可以通过 `CurvedAnimation` 来指定动画的曲线，如：

```
final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
```

`CurvedAnimation` 和 `AnimationController`（下面介绍）都是 `Animation<double>` 类型。

`CurvedAnimation` 可以通过包装 `AnimationController` 和 `Curve` 生成一个新的动画对象，我们正是通过这种方式来将动画和动画执行的曲线关联起来的。我们指定动画的曲线为 `Curves.easeIn`，它表示动画开始时比较慢，结束时比较快。`Curves` 类是一个预置的枚举类，定义了许多常用的曲线，下面列几种常用的：

![Curve曲线]()

除了上面列举的，`Curves` 类中还定义了许多其它的曲线，当然也可以创建自己 `Curve`，例如定义一个正弦曲线：

```
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.PI * 2);
  }
}
```

#### AnimationController

`AnimationController` 用于控制动画，它包含动画的启动 `forward()`、停止 `stop()`、反向播放 `reverse()` 等方法。