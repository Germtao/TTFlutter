# 文件操作

`Dart`的`IO库`包含了文件读写的相关类，它属于Dart语法标准的一部分，所以通过`Dart IO库`，无论是Dart VM下的脚本还是Flutter，都是通过Dart IO库来操作文件的，不过和Dart VM相比，Flutter有一个重要差异是文件系统路径不同，这是因为Dart VM是运行在PC或服务器操作系统下，而Flutter是运行在移动操作系统中，它们的文件系统会有一些差异。

## App目录

`Android`和`iOS`的应用存储目录不同，`PathProvider`插件提供了一种平台透明的方式来访问设备文件系统上的常用位置。该类当前支持访问两个文件系统位置：

- **临时目录**: 可以使用`getTemporaryDirectory()`来获取临时目录；系统可随时清除的临时目录（缓存）。在`iOS`上，这对应于`NSTemporaryDirectory()`返回的值。在`Android`上，这是`getCacheDir()`返回的值。

- **文档目录**: 可以使用`getApplicationDocumentsDirectory()`来获取应用程序的文档目录，该目录用于存储只有自己可以访问的文件。只有当应用程序被卸载时，系统才会清除该目录。在`iOS`上，这对应于`NSDocumentDirectory`。在`Android`上，这是`AppData`目录。

- **外部存储目录**：可以使用`getExternalStorageDirectory()`来获取外部存储目录，如SD卡；由于`iOS`*不支持*外部目录，所以在`iOS`下调用该方法会抛出`UnsupportedError`异常，而在`Android`下结果是`android SDK`中`getExternalStorageDirectory`的返回值。

一旦`Flutter`应用程序有一个文件位置的引用，可以使用`dart:io`API来执行对文件系统的读/写操作。有关使用Dart处理文件和目录的详细内容可以参考Dart语言文档，下面来看一个简单的例子。

## 示例

以计数器为例，实现在应用退出重启后可以恢复点击次数。 这里使用文件来保存数据：

1. 引入`PathProvider`插件；在`pubspec.yaml`文件中添加如下声明：

`path_provider: ^1.5.0`

添加后，执行`flutter packages get`获取一下, 版本号可能随着时间推移会发生变化，可以使用最新版。

**出现错误**

> WARNING: CocoaPods requires your terminal to be using UTF-8 encoding 
> Consider adding the following to ~/.profile:
> export LANG=en_US.UTF-8

**解决方案**

> 解决方案： 终端打开~/.bash_profile (open ~/.bash_profile)
> 编辑并添加 export LANG=en_US.UTF-8
> 退出并保存
> 还可以运行该echo $LANG命令以查看变量是否已正确配置。
> VSCODE 重新运行 若仍然显示错误，退出vscode 重新启动打开vscode。

2. 实现：

```
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class FileOperationTestRoute extends StatefulWidget {
  FileOperationTestRoute({Key key}) : super(key: key);

  @override
  _FileOperationTestRouteState createState() => _FileOperationTestRouteState();
}

class _FileOperationTestRouteState extends State<FileOperationTestRoute> {
  int _counter;

  @override
  void initState() {
    super.initState();
    // 从文件获取点击次数
    _readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _getLocalFile() async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/counter.txt');
  }

  Future<int> _readCounter() async {
    try {
      File file = await _getLocalFile();
      // 读取点击次数(以字符串)
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  Future<Null> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    // 将点击次数以字符串类型写到文件中
    await (await _getLocalFile()).writeAsString('$_counter');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('文件操作'),
        ),
        body: Center(
          child: Text('点击了 $_counter 次'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

在实际开发中，如果要存储一些简单的数据，使用`shared_preferences`插件会比较简单。