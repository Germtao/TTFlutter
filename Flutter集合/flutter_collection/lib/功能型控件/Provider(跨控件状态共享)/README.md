# 跨控件状态共享（Provider）

在`Flutter`开发中，状态管理是一个永恒的话题。

一般原则是：

- 如果状态是控件私有的，则应该由控件自己管理

- 如果状态要跨控件共享，则该状态应该由各个控件共同的父元素来管理

对于控件私有的状态管理很好理解，但对于跨控件共享的状态，管理的方式就比较多了，如使用全局事件总线EventBus，它是一个观察者模式的实现，通过它就可以实现跨控件状态同步：状态持有方（发布者）负责更新、发布状态，状态使用方（观察者）监听状态改变事件来执行一些操作。

下面我们看一个登陆状态同步的简单示例：

定义事件

```
enum Event{
login,
... //省略其它事件
}
```

登录页代码大致如下：

```
// 登录状态改变后发布状态改变事件
bus.emit(Event.login);
```

依赖登录状态的页面：

```
void onLoginChanged(e){
  // 登录状态变化处理逻辑
}

@override
void initState() {
  // 订阅登录状态改变事件
  bus.on(Event.login,onLogin);
  super.initState();
}

@override
void dispose() {
  // 取消订阅
  bus.off(Event.login,onLogin);
  super.dispose();
}
```

我们可以发现，通过观察者模式来实现跨控件状态共享有一些明显的缺点：

1. 必须显式定义各种事件，不好管理。

2. 订阅者必须需显式注册状态改变回调，也必须在控件销毁时手动去解绑回调以避免内存泄露。

> 在Flutter当中有没有更好的跨组件状态管理方式了呢？

答案是肯定的，那怎么做的？我们想想前面介绍的`InheritedWidget`，它的天生特性就是能绑定`InheritedWidget`与`依赖它的子孙控件的依赖关系`，并且当`InheritedWidget`数据发生变化时，可以自动更新依赖的子孙组件！

利用这个特性，我们可以将需要跨控件共享的状态保存在`InheritedWidget`中，然后在子控件中引用`InheritedWidget`即可，Flutter社区著名的`Provider`包正是基于这个思想实现的一套跨控件状态共享解决方案，接下来我们便详细介绍一下`Provider`的用法及原理。

# Provider

为了加强读者的理解，我们不直接去看`Provider`包的源代码，相反，我会带着你根据上面描述的通过`InheritedWidget`实现的思路来一步一步地实现一个最小功能的`Provider`。

首先，我们需要一个保存需要共享的数据`InheritedWidget`，由于具体业务数据类型不可预期，为了通用性，我们使用泛型，定义一个通用的`InheritedProvider`类，它继承自`InheritedWidget`：

```
// 一个通用的InheritedWidget，保存任意需要跨控件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({@required this.data, Widget child}) : super(child: child);

  //共享状态使用泛型
  final T data;

  @override
  bool updateShouldNotify(InheritedWidget<T> oldWidget) {
    // 在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}
```

数据保存的地方有了，那么接下来我们需要做的就是在数据发生变化的时候来重新构建`InheritedProvider`，那么现在就面临两个问题：

1. 数据发生变化怎么通知？

2. 谁来重新构建`InheritedProvider`？

第一个问题其实很好解决，我们当然可以使用之前介绍的`eventBus`来进行事件通知，但是为了更贴近`Flutter`开发，我们使用`Flutter`中SDK中提供的`ChangeNotifier`类 ，它继承自`Listenable`，也实现了一个Flutter风格的发布者-订阅者模式，`ChangeNotifier`定义大致如下：

```
class ChangeNotifier implements Listenable {
  @override
  void addListener(listener) {
    // TODO: 添加监听器
  }

  @override
  void removeListener(listener) {
    // TODO: 移除监听器
  }

  void notifyListener() {
    // TODO: 通知所有监听器，触发监听器回调
  }
}
```

我们可以通过调用`addListener()`和`removeListener()`来添加、移除监听器（订阅者）；通过调用`notifyListeners()`可以触发所有监听器回调。

现在，我们将要共享的状态放到一个`Model`类中，然后让它继承自`ChangeNotifier`，这样当共享的状态改变时，我们只需要调用`notifyListeners()`来通知订阅者，然后由订阅者来重新构建`InheritedProvider`，这也是第二个问题的答案！接下来我们便实现这个订阅者类：

```
// 该方法用于在Dart中获取模板类型
Type _typeOf<T>() => Type;

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({
    Key key,
    this.data,
    this.child,
  });

  final Widget child;
  final T data;

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static T of<T>(BuildContext context) {
    final type = _typeOf<InheritedProvider<T>>();
    final provider =
        context.inheritFromWidgetOfExactType(type) as InheritedProvider<T>;
    return provider.data;
  }
```

该类继承`StatefulWidget`，然后定义了一个`of()`静态方法供子类方便获取`Widget`树中的`InheritedProvider`中保存的共享状态(model)，下面我们实现该类对应的`_ChangeNotifierProviderState`类：

```
class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider> {
  void update() {
    // 如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    // 当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}
```

可以看到`_ChangeNotifierProviderState`类的主要作用监听到共享状态（model）改变时重新构建Widget树。注意，在`_ChangeNotifierProviderState`类中调用`setState()`方法，`widget.child`始终是同一个，所以执行`build`时，`InheritedProvider`的`child`引用的始终是同一个子`widget`，所以`widget.child`并不会重新`build`，这也就相当于对`child`进行了缓存！当然如果`ChangeNotifierProvider`父级`Widget`重新`build`时，则其传入的`child`便有可能会发生变化。

现在我们所需要的各个工具类都已完成，下面我们通过一个购物车的例子来看看怎么使用上面的这些类。