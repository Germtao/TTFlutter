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



#### 总结

通过组合的方式定义控件和之前写界面并无差异，不过在抽离出单独的控件时要考虑代码规范性，如必要参数要用`@required`标注，对于可选参数在特定场景需要判空或设置默认值等。这是由于使用者大多时候可能不了解控件的内部细节，所以为了保证代码健壮性，需要在用户错误地使用控件时能够兼容或报错提示（使用`assert`断言函数）。