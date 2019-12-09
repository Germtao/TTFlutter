# 自定义控件

## 自定义控件方法简介

当 `Flutter` 提供的现有控件无法满足我们的需求，或者我们为了共享代码需要封装一些通用控件，这时就需要自定义控件。

在 `Flutter` 中自定义控件有三种方式：

- 组合其它 `Widget`

    这种方式是通过拼装其它控件来组合成一个新的控件。例如我们之前介绍的 `Container` 就是一个组合控件，它是由 `DecoratedBox`、`ConstrainedBox`、`Transform`、`Padding`、`Align`等控件组成。

    在 `Flutter` 中，组合的思想非常重要，`Flutter` 提供了非常多的基础控件，而我们的界面开发其实就是按照需要组合这些控件来实现各种不同的布局而已。

- 自绘

    如果遇到无法通过现有的控件来实现需要的 `UI` 时，可以通过自绘组件的方式来实现，例如需要一个颜色渐变的圆形进度条，而 `Flutter` 提供的 `CircularProgressIndicator` 并不支持在显示精确进度时对进度条应用渐变色（其 `valueColor` 属性只支持执行旋转动画时变化 `Indicator` 的颜色），这时最好的方法就是通过自定义控件来绘制出期望的外观。可以通过 `Flutter` 中提供的 `CustomPaint` 和 `Canvas` 来实现 `UI自绘`。

- 实现 `RenderObject`

    `Flutter` 提供的自身具有UI外观的控件，如 `文本Text`、`Image` 都是通过相应的 `RenderObject`（将在“Flutter核心原理”一章中详细介绍RenderObject）渲染出来的，如 `Text` 是由 `RenderParagraph` 渲染；而 `Image` 是由 `RenderImage` 渲染。`RenderObject` 是一个抽象类，它定义了一个抽象方法 `paint(...)`：

    `void paint(PaintingContext context, Offset offset)`

    `PaintingContext` 代表控件的绘制上下文，通过 `PaintingContext.canvas` 可以获得 `Canvas`，而绘制逻辑主要是通过`Canvas` API来实现。子类需要重写此方法以实现自身的绘制逻辑，如 `RenderParagraph` 需要实现文本绘制逻辑，而`RenderImage` 需要实现图片绘制逻辑。

    > 可以发现，`RenderObject` 中最终也是通过 `Canvas` API来绘制的，那么通过实现 `RenderObject` 的方式和上面介绍的通过> `CustomPaint` 和 `Canvas` 自绘的方式有什么区别？
    
    其实答案很简单，`CustomPaint` 只是为了方便开发者封装的一个代理类，它直接继承自 `SingleChildRenderObjectWidget`，通过 `RenderCustomPaint` 的 `paint` 方法将 `Canvas `和画笔 `Painter` (需要开发者实现，后面章节介绍)连接起来实现了最终的绘制（绘制逻辑在Painter中）。

**总而言之**

“组合”是自定义控件最简单的方法，在任何需要自定义控件的场景下，我们都应该优先考虑是否能够通过组合来实现。而自绘和通过实现`RenderObject` 的方法本质上是一样的，都需要开发者调用 `Canvas` API手动去绘制UI，优点是强大灵活，理论上可以实现任何外观的UI，而缺点是必须了解 `Canvas` API细节，并且得自己去实现绘制逻辑。

---

## 组合现有控件

在`Flutter`中页面UI通常都是由一些低阶别的控件组合而成，当我们需要封装一些通用控件时，应该首先考虑是否可以通过组合其它控件来实现，如果可以，则应优先使用组合，因为直接通过现有控件拼装会非常*简单*、*灵活*、*高效*。

#### 示例1：自定义渐变按钮

`Flutter Material`控件库中的按钮默认不支持渐变背景，为了实现渐变背景按钮，我们自定义一个`GradientButton`控件，它需要支持一下功能：

1. 背景支持渐变色

2. 手指按下时有涟漪效果

3. 可以支持圆角

效果图如下：

![渐变色按钮]()

`DecoratedBox`可以支持背景色渐变和圆角，`InkWell`在手指按下有涟漪效果，所以可以通过组合`DecoratedBox`和`InkWell`来实现`GradientButton`，代码如下：

```
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
```

可以看到`GradientButton`是由`DecoratedBox`、`Padding`、`Center`、`InkWell`等控件组合而成。当然上面的代码只是一个示例，作为一个按钮它还并不完整，比如没有禁用状态，后续可以根据实际需要来完善。

#### 示例2：TurnBox

之前介绍过的`RotatedBox`，它可以旋转子控件，但是它有两个**缺点**：一是只能将其子节点以90度的倍数旋转；二是当旋转的角度发生变化时，旋转角度更新过程没有动画。

将实现一个`TurnBox`控件，它不仅可以以任意角度来旋转其子节点，而且可以在角度发生变化时执行一个动画以过渡到新状态，同时，可以手动指定动画速度。

`TurnBox`的完整代码如下：

```
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
```

#### 总结

通过组合的方式定义控件和之前写界面并无差异，不过在抽离出单独的控件时要考虑代码规范性，如必要参数要用`@required`标注，对于可选参数在特定场景需要判空或设置默认值等。这是由于使用者大多时候可能不了解控件的内部细节，所以为了保证代码健壮性，需要在用户错误地使用控件时能够兼容或报错提示（使用`assert`断言函数）。

--- 

## 自绘控件

对于一些复杂或不规则的UI，可能无法通过组合其它控件的方式来实现，比如需要一个正六边形、一个渐变的圆形进度条、一个棋盘等。当然，有时候可以使用图片来实现，但在一些需要动态交互的场景静态图片也是实现不了的，比如要实现一个手写输入面板，这时就需要来自己绘制UI外观。

几乎所有的UI系统都会提供一个自绘UI的接口，这个接口通常会提供一块`2D画布Canvas`，`Canvas`内部封装了一些基本绘制的API，开发者可以通过`Canvas`绘制各种自定义图形。在`Flutter`中，提供了一个`CustomPaint`控件，它可以结合画笔`CustomPainter`来实现自定义图形绘制。

#### CustomPaint

看看CustomPaint构造函数：

```
CustomPaint({
  Key key,
  this.painter, 
  this.foregroundPainter,
  this.size = Size.zero, 
  this.isComplex = false, 
  this.willChange = false, 
  Widget child, // 子节点，可以为空
})
```

- `painter`: 背景画笔，会显示在子节点后面
- `foregroundPainter`: 前景画笔，会显示在子节点前面
- `size`：当`child`为`null`时，代表默认绘制区域大小，如果有`child`则忽略此参数，画布尺寸则为`child`尺寸。如果有`child`但是想指定画布为特定大小，可以使用`SizeBox`包裹`CustomPaint`实现
- `isComplex`：是否复杂的绘制，如果是，`Flutter`会应用一些缓存策略来减少重复渲染的开销
- `willChange`：和`isComplex`配合使用，当启用缓存时，该属性代表在下一帧中绘制是否会改变

可以看到，绘制时需要提供前景或背景画笔，两者也可以同时提供。画笔需要继承`CustomPainter`类，在画笔类中实现真正的绘制逻辑。

> **注意**

如果`CustomPaint`有子节点，为了避免子节点不必要的重绘并提高性能，通常情况下都会将子节点包裹在`RepaintBoundary`控件中，这样会在绘制时就会创建一个`新的绘制层(Layer)`，其子控件将在新的`Layer`上绘制，而父控件将在原来`Layer`上绘制，也就是说`RepaintBoundary`子控件的绘制将独立于父控件的绘制，`RepaintBoundary`会隔离其子节点和`CustomPaint`本身的绘制边界。示例如下：

```
CustomPaint(
  size: Size(300, 300), // 指定画布大小
  painter: MyPainter(),
  child: RepaintBoundary(child:...)), 
)
```

#### CustomPainter

`CustomPainter`中提定义了一个虚函数`paint`：

`void paint(Canvas canvas, Size size);`

`paint`有两个参数:

- `Canvas`：一个画布，包括各种绘制方法，列出一下常用的方法：

> |API名称 | 功能 | | ---------- | ------ | | `drawLine` | 画线 | | `drawPoint` | 画点 | | `drawPath` | 画路径 | | `drawImage` | 画图像 | | `drawRect` | 画矩形 | | `drawCircle` | 画圆 | | `drawOval` | 画椭圆 | | `drawArc` | 画圆弧 |

- `Size`：当前绘制区域大小


#### 画笔Paint

现在画布有了，最后还缺一个画笔，`Flutter`提供了`Paint`类来实现画笔。在`Paint`中，可以配置画笔的各种属性如粗细、颜色、样式等。如：

```
var paint = Paint()           // 创建一个画笔并配置其属性
  ..isAntiAlias = true        // 是否抗锯齿
  ..style = PaintingStyle.fill // 画笔样式：填充
  ..color=Color(0x77cdb175);  // 画笔颜色
```

更多的配置属性可以参考Paint类定义。

---

#### 示例1: 五子棋/盘

下面通过一个五子棋游戏中棋盘和棋子的绘制来演示自绘UI的过程，首先看一下目标效果，如下图所示：

![五子棋/盘]()

```
class TTPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / 15;
    double eHeight = size.height / 15;

    // 画棋盘背景
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill // 填充
      ..color = Color(0x77cdb175); // 背景为纸黄色

    // 画棋盘网格
    paint
      ..style = PaintingStyle.stroke // 线
      ..color = Colors.black87
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 15; i++) {
      double dy = eHeight * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }

    for (int i = 0; i <= 15; i++) {
      double dx = eWidth * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    // 画一个黑子
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawCircle(
      Offset((size.width - eWidth) / 2, (size.height - eHeight) / 2),
      min(eWidth / 2, eHeight / 2) - 2,
      paint,
    );

    // 画一个白子
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset((size.width + eWidth) / 2, (size.height - eHeight) / 2),
      min(eWidth / 2, eHeight / 2) - 2,
      paint,
    );
  }

  // 在实际场景中正确利用此回调可以避免重绘开销，本示例简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
```

#### 示例2: 圆形背景渐变进度条

实现一个圆形背景渐变进度条：

1. 支持多种背景渐变色
2. 任意弧度；进度条可以不是整圆
3. 可以自定义粗细、两端是否圆角等样式

可以发现要实现这样的一个进度条是无法通过现有控件组合而成的，所以通过自绘方式实现，代码如下：

```
class GradientCircularProgressIndicator extends StatelessWidget {
  GradientCircularProgressIndicator({
    this.strokeWidth = 2.0,
    @required this.radius,
    @required this.colors,
    this.stops,
    this.strokeCapRound = false,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.totalAngle = 2 * pi,
    this.value,
  });

  /// 粗细
  final double strokeWidth;

  /// 圆的半径
  final double radius;

  /// 两端是否为圆角
  final bool strokeCapRound;

  /// 当前进度, 取值范围 [0.0, 1.0]
  final double value;

  /// 进度条背景色
  final Color backgroundColor;

  /// 进度条总弧度, 2 * pi 为整圆, 小于 2 * pi 则不是整圆
  final double totalAngle;

  /// 渐变色数���
  final List<Color> colors;

  /// 渐变色的终止点, 对应colors属性
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    double _offset = .0;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出，读者有兴趣可以研究一下为什么是这样
    if (strokeCapRound) {
      _offset = asin(strokeWidth / (radius * 2 - strokeWidth));
    }
    var _colors = colors;
    if (_colors == null) {
      Color color = Theme.of(context).accentColor;
      _colors = [color, color];
    }
    return Transform.rotate(
      angle: -pi / 2 - _offset,
      child: CustomPaint(
        size: Size.fromRadius(radius),
        painter: _GradientCircularProgressPainter(
          strokeWidth: strokeWidth,
          strokeCapRound: strokeCapRound,
          backgroundColor: backgroundColor,
          value: value,
          total: totalAngle,
          radius: radius,
          colors: _colors,
        ),
      ),
    );
  }
}

// 实现画笔
class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter({
    this.strokeWidth: 10.0,
    this.strokeCapRound: false,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.radius,
    this.total = 2 * pi,
    @required this.colors,
    this.stops,
    this.value,
  });

  final double strokeWidth;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;
  final List<Color> colors;
  final double total;
  final double radius;
  final List<double> stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius);
    }
    double _offset = strokeWidth / 2.0;
    double _value = value ?? .0;
    _value = _value.clamp(.0, 1.0) * total;
    double _start = .0;

    if (strokeCapRound) {
      _start = asin(strokeWidth / (size.width - strokeWidth));
    }

    Rect rect = Offset(_offset, _offset) &
        Size(
          size.width - strokeWidth,
          size.height - strokeWidth,
        );

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    // 先画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, _start, total, false, paint);
    }

    // 再画前景，应用渐变
    if (_value > 0) {
      paint.shader = SweepGradient(
        startAngle: .0,
        endAngle: _value,
        colors: colors,
        stops: stops,
      ).createShader(rect);

      canvas.drawArc(rect, _start, _value, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
```

--- 

### 性能

绘制是比较昂贵的操作，所以在实现自绘控件时应该考虑到性能开销，下面是两条关于性能优化的建议：

- 尽可能的利用好`shouldRepaint`返回值；在UI树重新build时，控件在绘制前都会先调用该方法以确定是否有必要重绘；假如绘制的UI**不依赖外部状态**，那么就应该始终返回`false`，因为外部状态改变导致重新build时不会影响UI外观；如果**绘制依赖外部状态**，那么就应该在`shouldRepaint`中判断依赖的状态是否改变，如果已改变则应返回true来重绘，反之则应返回false不需要重绘。

- 绘制尽可能多的分层。在上面五子棋的示例中，将棋盘和棋子的绘制放在了一起，这样会有一个问题：由于棋盘始终是不变的，用户每次落子时变的只是棋子，但是如果按照上面的代码来实现，每次绘制棋子时都要重新绘制一次棋盘，这是没必要的。优化的方法就是将棋盘单独抽为一个控件，并设置其`shouldRepaint`回调值为`false`，然后将棋盘控件作为背景。然后将棋子的绘制放到另一个控件中，这样每次落子时只需要绘制棋子。

### 总结

自绘控件非常强大，理论上可以实现任何2D图形外观，实际上Flutter提供的所有控件最终都是通过调用`Canvas`绘制出来的，只不过绘制的逻辑被封装起来了，有兴趣可以查看具有外观样式的组件源码，找到其对应的`RenderObject`对象，如`Text`对应的`RenderParagraph`对象最终会通过`Canvas`实现文本绘制逻辑。






