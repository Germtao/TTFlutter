# 事件处理与通知

- [原始指针事件处理](https://github.com/Germtao/TTFlutter/tree/master/Flutter%E9%9B%86%E5%90%88/flutter_collection/lib/Advanced#%E5%8E%9F%E5%A7%8B%E6%8C%87%E9%92%88%E4%BA%8B%E4%BB%B6%E5%A4%84%E7%90%86-pointer-event)

## 原始指针事件处理 （Pointer Event）

在移动端，各个平台或UI系统的原始指针事件模型基本都是一致，即：一次完整的事件分为三个阶段：手指按下、手指移动、和手指抬起，而更高级别的手势（如点击、双击、拖动等）都是基于这些原始事件的。

当指针按下时，`Flutter`会对应用程序执行*命中测试(Hit Test)*，以确定指针与屏幕接触的位置存在哪些控件（widget），指针按下事件（以及该指针的后续事件）然后被分发到由命中测试发现的最内部的控件，然后从那里开始，事件会在控件树中向上冒泡，这些事件会从最内部的控件被分发到控件树根的路径上的所有控件，这和Web开发中浏览器的事件冒泡机制相似，但是`Flutter`中没有机制取消或停止“冒泡”过程，而浏览器的冒泡是可以停止的。注意，只有通过命中测试的组件才能触发事件。

`Flutter`中可以使用`Listener`来监听原始触摸事件，按照本书对控件的分类，则`Listener`也是一个功能性控件。下面是`Listener`的构造函数定义：

```
Listener({
  Key key,
  this.onPointerDown, // 手指按下回调
  this.onPointerMove, // 手指移动回调
  this.onPointerUp, // 手指抬起回调
  this.onPointerCancel, // 触摸事件取消回调
  this.behavior = HitTestBehavior.deferToChild, // 在命中测试期间如何表现
  Widget child
})
```

我们先看一个示例，后面再单独讨论一下`behavior`属性。

```
class PointerEventTestRoute extends StatefulWidget {
  @override
  _PointerEventTestRouteState createState() => _PointerEventTestRouteState();
}

class _PointerEventTestRouteState extends State<PointerEventTestRoute> {
  PointerEvent _event; // 定义一个状态，保存当前指针位置
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blueAccent),
      child: Scaffold(
        appBar: AppBar(title: Text('原始指针事件处理')),
        body: Listener(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue,
            width: 300.0,
            height: 150.0,
            child: Text(
              _event?.toString() ?? "",
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPointerDown: (event) => setState(() => _event = event),
          onPointerMove: (event) => setState(() => _event = event),
          onPointerUp: (event) => setState(() => _event = event),
        ),
      ),
    );
  }
}
```

手指在蓝色矩形区域内移动即可看到当前指针偏移，当触发指针事件时，参数`PointerDownEvent`、`PointerMoveEvent`、`PointerUpEvent`都是`PointerEvent`的一个子类，`PointerEvent`类中包括当前指针的一些信息，如：

- `position`：它是鼠标相对于当对于全局坐标的偏移

- `delta`：两次指针移动事件（`PointerMoveEvent`）的距离

- `pressure`：按压力度，如果手机屏幕支持压力传感器(如iPhone的3D Touch)，此属性会更有意义，如果手机不支持，则始终为1

- `orientation`：指针移动方向，是一个角度值

上面只是PointerEvent一些常用属性，除了这些它还有很多属性，可以查看API文档。

现在，我们重点来介绍一下`behavior`属性，它决定子控件如何响应命中测试，它的值类型为`HitTestBehavior`，这是一个枚举类，有三个枚举值：

- `deferToChild`：子控件会一个接一个的进行命中测试，如果子控件中有测试通过的，则当前控件通过，这就意味着，如果指针事件作用于子控件上时，其父级控件也肯定可以收到该事件

- `opaque`：在命中测试时，将当前控件当成不透明处理(即使本身是透明的)，最终的效果相当于`当前Widget`的整个区域都是点击区域。举个例子：

```
Listener(
  child: ConstrainedBox(
    constraints: BoxConstraints.tight(Size(300.0, 150.0)),
    child: Center(
      child: Text(
        'Box A',
        style:
          TextStyle(color: Colors.white, backgroundColor: Colors.red),
        ),
      ),
    ),
  //behavior: HitTestBehavior.opaque,
  onPointerDown: (event) => print('down Box A'),
),
```

上例中，只有点击文本内容区域才会触发点击事件，因为 `deferToChild` 会去子控件判断是否命中测试，而该例中子控件就是 `Text("Box A")` 。如果我们想让整个`300×150`的矩形区域都能点击我们可以将`behavior`设为`HitTestBehavior.opaque`。注意，该属性并不能用于在控件树中拦截（忽略）事件，它只是决定命中测试时的控件大小。

- `translucent`：当点击控件透明区域时，可以对自身边界内及底部可视区域都进行命中测试，这意味着点击顶部控件透明区域时，顶部控件和底部控件都可以接收到事件，例如：

```
Stack(
  children: <Widget>[
    Listener(
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(Size(300.0, 200.0)),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue),
        ),
      ),
      onPointerDown: (event) => print('down - 0'),
    ),
    Listener(
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(Size(200.0, 100.0)),
        child: Center(
          child: Text(
            '左上角200*100范围内非文本区域点击',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onPointerDown: (event) => print('down - 1'),
      //behavior: HitTestBehavior.translucent,
    ),
  ],
),
```

上例中，当注释掉最后一行代码后，在左上角200*100范围内非文本区域点击时（顶部组件透明区域），控制台只会打印“down0”，也就是说顶部组件没有接收到事件，而只有底部接收到了。当放开注释后，再点击时顶部和底部都会接收到事件，此时会打印：

```
flutter: down - 1
flutter: down - 0
```

如果`behavior`值改为`HitTestBehavior.opaque`，则只会打印`down - 1`。

#### 忽略PointerEvent

假如不想让某个子树响应`PointerEvent`的话，可以使用以下两个控件都能阻止子树接收指针事件，不同之处：

- `IgnorePointer`：本身*会*参与命中测试，因为它可以接收指针事件的（但其子树不行）

- `AbsorbPointer`：本身*不会*参与命中测试，因为它不可以接收指针事件

举个简单的例子：

```
Listener(
  child: AbsorbPointer(
    child: Listener(
      child: Container(
        color: Colors.red,
        width: 200.0,
        height: 100.0,
      ),
      onPointerDown: (event) => print('in'),
    ),
  ),
  onPointerDown: (event) => print('up'),
),
```

点击`Container`时，由于它在`AbsorbPointer`的子树上，所以不会响应指针事件，所以日志不会输出`in`，但`AbsorbPointer`本身是可以接收指针事件的，所以会输出`up`。如果将`AbsorbPointer`换成`IgnorePointer`，那么两个都不会输出。

---

## 手势识别

### GestureDetector

`GestureDetector`是一个用于手势识别的功能性组件，我们通过它可以来识别各种手势。`GestureDetector`实际上是指针事件的语义化封装，接下来我们详细介绍一下各种手势识别。

#### 点击、双击、长按

通过`GestureDetector`对`Container`进行手势识别，触发相应事件后，在`Container`上显示事件名，为了增大点击区域，将`Container`设置为`200×100`，代码如下：

```
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
```

> *注意*： 当同时监听`onTap`和`onDoubleTap`事件时，当用户触发tap事件时，会有`200毫秒`左右的延时，这是因为当用户点击完之后很可能会再次点击以触发双击事件，所以`GestureDetector`会等一段时间来确定是否为双击事件。如果用户只监听了`onTap`（没有监听`onDoubleTap`）事件时，则没有延时。

#### 拖动、滑动

一次完整的手势过程是指用户手指按下到抬起的整个过程，期间，用户按下手指后可能会移动，也可能不会移动。`GestureDetector`对于拖动和滑动事件是没有区分的，他们本质上是一样的。`GestureDetector`会将要监听的组件的原点（左上角）作为本次手势的原点，当用户在监听的组件上按下手指时，手势识别就会开始。下面我们看一个拖动圆形字母A的示例：

```
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
```

打印日志：

```
flutter: 用户手指按下：Offset(129.5, 673.0)
flutter: Velocity(668.3, 14.1)
```

代码解释：

- `DragDownDetails.globalPosition`：当用户按下时，此属性为用户按下的位置相对于*屏幕*（而非父组件）原点(左上角)的偏移

- `DragUpdateDetails.delta`：当用户在屏幕上滑动时，会触发多次`Update`事件，`delta`指一次`Update`事件的滑动的偏移量

- `DragEndDetails.velocity`：该属性代表用户抬起手指时的滑动速度(包含x、y两个轴的），示例中并没有处理手指抬起时的速度，常见的效果是根据用户抬起手指时的速度做一个减速动画

### GestureRecognizer

`GestureDetector`内部是使用一个或多个`GestureRecognizer`来识别各种手势的，而`GestureRecognizer`的作用就是通过`Listener`来将原始指针事件转换为语义手势，`GestureDetector`直接可以接收一个子widget。`GestureRecognizer`是一个抽象类，一种手势的识别器对应一个`GestureRecognizer`的子类，`Flutter`实现了丰富的手势识别器，我们可以直接使用。

#### 示例

假设要给一段富文本（`RichText`）的不同部分分别添加点击事件处理器，但是`TextSpan`并不是一个widget，这时我们不能用`GestureDetector`，但`TextSpan`有一个`recognizer`属性，它可以接收一个`GestureRecognizer`。

假设需要在点击时给文本变色：

```
  TapGestureRecognizer _tapGes = TapGestureRecognizer();
  bool _toggle = false; // 变色开关

  @override
  void dispose() {
    // 用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGes.dispose();
    super.dispose();
  }

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
```

> *注意*：使用`GestureRecognizer`后一定要调用其`dispose()`方法来释放资源（主要是取消内部的计时器）。

### 手势竞争与冲突

#### 竞争

如果在上例中我们同时监听水平和垂直方向的拖动事件，那么我们斜着拖动时哪个方向会生效？实际上取决于第一次移动时两个轴上的位移分量，哪个轴的大，哪个轴在本次滑动事件竞争中就胜出。实际上`Flutter`中的手势识别引入了一个`Arena`的概念，`Arena`直译为“竞技场”的意思，每一个`手势识别器（GestureRecognizer）`都是一个`竞争者（GestureArenaMember）`，当发生滑动事件时，他们都要在“竞技场”去竞争本次事件的处理权，而最终只有一个“竞争者”会胜出(win)。

例如，假设有一个`ListView`，它的第一个子控件也是`ListView`，如果现在滑动这个`子ListView`，`父ListView`会动吗？答案是否定的，这时只有`子ListView`会动，因为这时`子ListView`会胜出而获得滑动事件的处理权。

#### 示例

我们以拖动手势为例，同时识别水平和垂直方向的拖动手势，当用户按下手指时就会触发竞争（水平方向和垂直方向），一旦某个方向“获胜”，则直到当次拖动手势结束都会沿着该方向移动。代码如下：

```
Widget _bothDirectionOfDrag() {
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
            // 垂直方向拖动事件
            onVerticalDragUpdate: (details) {
            setState(() {
              _top += details.delta.dy;
            });
          },

          // 水平方向拖动事件
          onHorizontalDragUpdate: (details) {
            setState(() {
              _left += details.delta.dx;
            });
          },
        ),
      ),
    ],
  ),
);
}
```

此示例运行后，每次拖动只会沿一个方向移动（水平或垂直），而竞争发生在手指按下后首次移动（move）时，此例中具体的“获胜”条件是：首次移动时的位移在水平和垂直方向上的分量大的一个获胜。

#### 手势冲突

由于手势竞争最终只有一个胜出者，所以，当有多个手势识别器时，可能会产生冲突。假设有一个widget，它可以左右拖动，现在我们也想检测在它上面手指按下和抬起的事件，代码如下：

```
double _left2 = 0.0;

// 手势冲突
Widget _gestureConflictTest() {
  return Container(
    width: 200,
    height: 100,
    color: Colors.tealAccent,
    child: Stack(
      children: <Widget>[
        Positioned(
          left: _left2,
          child: GestureDetector(
            child: CircleAvatar(child: Text('A')),
            onHorizontalDragUpdate: (details) {
              setState(() {
                _left2 += details.delta.dx;
              });
            },
            onHorizontalDragEnd: (details) {
              print('onHorizontalDragEnd');
            },
            onTapDown: (details) {
              print('down');
            },
            onTapUp: (details) {
              print('up');
            },
          ),
        ),
      ],
    ),
  );
}
```

现在我们按住圆形“A”拖动然后抬起手指，控制台日志如下:

```
flutter: down
flutter: onHorizontalDragEnd
```

- 没有打印 `up`，这是因为在拖动时，刚开始按下手指时在没有移动时，拖动手势还没有完整的语义，此时 `TapDown` 手势胜出(win)，此时打印 `down`
- 而拖动时，拖动手势会胜出，当手指抬起时，`onHorizontalDragEnd` 和 `onTapUp` 发生了冲突，但是因为是在拖动的语义中，所以`onHorizontalDragEnd` 胜出，所以就会打印 `onHorizontalDragEnd`

如果代码逻辑中，对于手指按下和抬起是强依赖的，比如在一个轮播图组件中，我们希望手指按下时，暂停轮播，而抬起时恢复轮播，但是由于轮播图组件中本身可能已经处理了拖动手势（支持手动滑动切换），甚至可能也支持了缩放手势，这时我们如果在外部再用 `onTapDown`、`onTapUp` 来监听的话是不行的。这时我们应该怎么做？其实很简单，通过 `Listener` 监听原始指针事件就行：

```
// 处理手势冲突
Widget _gestureConflictDeal() {
  return Container(
    width: 200.0,
    height: 200.0,
    color: Colors.pink,
    child: Stack(
      children: <Widget>[
        Positioned(
          left: _left3,
          child: Listener(
            onPointerDown: (details) {
              print('down');
            },
            onPointerUp: (details) {
              print('up');
            },
            child: GestureDetector(
              child: CircleAvatar(child: Text('A')),
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _left3 += details.delta.dx;
                });
              },
              onHorizontalDragEnd: (details) {
                print('onHorizontalDragEnd');
              },
            ),
          ),
        ),
      ],
    ),
  );
}
```

手势冲突只是手势级别的，而手势是对原始指针的语义化的识别，所以在遇到复杂的冲突场景时，都可以通过 `Listener` 直接识别原始指针事件来解决冲突。

--- 

## 事件总线

在APP中，我们经常会需要一个广播机制，用以跨页面事件通知，比如一个需要登录的APP中，页面会关注用户登录或注销事件，来进行一些状态更新。
这时候，一个事件总线便会非常有用，`事件总线` 通常实现了`订阅者模式`，`订阅者模式` 包含 `发布者` 和 `订阅者` 两种角色，可以通过事件总线来 `触发事件` 和 `监听事件`，本节我们实现一个简单的全局事件总线，我们使用单例模式，代码如下：

```
// MARK: - 事件总线
// 订阅者回调签名
typedef void EventCallback(arg);

class EventBus {
  // 私有构造函数
  EventBus._internal();

  // 保存单例
  static EventBus _singleton = EventBus._internal();

  // 工厂构造函数
  factory EventBus() => _singleton;

  // 保存事件订阅者队列, key: 事件名(id), value: 对应事件的订阅者队列
  var _emap = Map<Object, List<EventCallback>>();

  // 添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;

    _emap[eventName] ??= List<EventCallback>();
    _emap[eventName].add(f);
  }

  // 移除订阅者
  void off(eventName, EventCallback f) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // 触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;

    // 反向遍历, 防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }

  // 定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
  var bus = EventBus();
}
```

使用示例：

```
//页面A中
...
 //监听登录事件
bus.on('login', (arg) {
  // do something
});

//登录页B中
...
//登录成功后触发登录事件，页面A中订阅者会被调用
bus.emit('login', userInfo);
```

> 注：`Dart` 中实现单例模式的标准做法就是使用 `static变量` + `工厂构造函数` 的方式，这样就可以保证 `new EventBus()` 始终返回都是同一个实例，读者应该理解并掌握这种方法。

事件总线通常用于组件之间状态共享，但关于组件之间状态共享也有一些专门的包如 `redux`、以及前面介绍过的 `Provider`。对于一些简单的应用，事件总线是足以满足业务需求的。

如果你决定使用状态管理包的话，一定要想清楚您的APP是否真的有必要使用它，防止 `化简为繁`、`过度设计`。

--- 

## 通知（Notification）

### 系统通知

`Notification` 是Flutter中一个重要的机制，在widget树中，每一个节点都可以分发通知，通知会沿着当前节点向上传递，所有父节点都可以通过 `NotificationListener` 来监听通知。
Flutter中将这种 `由子向父` 的传递通知的机制称为`通知冒泡（Notification Bubbling）`。通知冒泡和用户触摸事件冒泡是相似的，但有一点不同：通知冒泡可以中止，但用户触摸事件不行。

> 通知冒泡和Web开发中浏览器事件冒泡原理是相似的，都是事件从出发源逐层向上传递，我们可以在上层节点任意位置来监听通知/事件，也可以终止冒泡过程，终止冒泡后，通知将不会再向上传递。

Flutter中很多地方使用了通知，如`可滚动组件（Scrollable Widget）`滑动时就会分发 `滚动通知（ScrollNotification）`，而Scrollbar正是通过监听ScrollNotification来确定滚动条位置的。

下面是一个监听可滚动组件滚动通知的例子：

```
NotificationListener(
  onNotification: (notification) {
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        print('-----开始滚动');
        break;
      case ScrollUpdateNotification:
        print('++++++正在滚动');
        break;
      case ScrollEndNotification:
        print('*******滚动停止');
        break;
    }
    return true;
  },
  child: ListView.builder(
    itemCount: 100,
    itemBuilder: (context, index) {
      return ListTile(title: Text('$index'));
    },
  ),
)
```

上例中的滚动通知如 `ScrollStartNotification`、`ScrollUpdateNotification` 等都是继承自 `ScrollNotification` 类，不同类型的通知子类会包含不同的信息，比如 `ScrollUpdateNotification` 有一个 `scrollDelta` 属性，它记录了移动的位移。

上例中，我们通过 `NotificationListener` 来监听 `子ListView` 的滚动通知的，`NotificationListener` 定义如下：

```
class NotificationListener<T extends Notification> extends StatelessWidget {
  /// Creates a widget that listens for notifications.
  const NotificationListener({
    Key key,
    @required this.child,
    this.onNotification,
  }) : super(key: key);
  // ... 省略无关代码
}
```

我们可以看到：

1. `NotificationListener` 继承自 `StatelessWidget` 类，所以它可以直接嵌套到Widget树中。

2. `NotificationListener` 可以指定一个模板参数，该模板参数类型必须是继承自 `Notification`；当显式指定模板参数时，`NotificationListener` 便只会接收该参数类型的通知。举个例子，如果我们将上例子代码给为：

    ```
    // 指定监听通知的类型为滚动结束通知(ScrollEndNotification)
    NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        // 只会在滚动结束时才会触发此回调
        print(notification);
        return true;
      },
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(title: Text('$index'));
        },
      ),
    )
    ```

    上面代码运行后便只会在滚动结束时在控制台打印出通知的信息：

    ```
    flutter: ScrollEndNotification(depth: 0 (local), FixedScrollMetrics(785.0..[796.0]..4053.0))
    ```

3. `onNotification` 回调为通知处理回调，其函数签名如下：

    ```
    typedef NotificationListenerCallback<T extends Notification> = bool Function(T notification);
    ```

    它的返回值类型为布尔值，当返回值为 `true` 时，阻止冒泡，其父级Widget将再也收不到该通知；当返回值为 `false` 时继续向上冒泡通知。

Flutter的UI框架实现中，除了在可滚动组件在滚动过程中会发出 `ScrollNotification` 之外，还有一些其它的通知，如 `SizeChangedLayoutNotification`、`KeepAliveNotification`、`LayoutChangedNotification` 等，Flutter正是通过这种通知机制来使父元素可以在一些特定时机来做一些事情。

### 自定义通知