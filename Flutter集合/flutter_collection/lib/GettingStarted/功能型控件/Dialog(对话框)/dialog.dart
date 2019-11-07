import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_collection/GettingStarted/功能型控件/Dialog(对话框)/dialog_check_box.dart';

// 对话框
class DialogTestRoute extends StatefulWidget {
  @override
  _DialogTestRouteState createState() => _DialogTestRouteState();
}

class _DialogTestRouteState extends State<DialogTestRoute> {
  bool withTree = false; // 复选框选中状态

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blueAccent),
      child: Scaffold(
        appBar: AppBar(
          title: Text('对话框'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('对话框 1'),
                onPressed: () async {
                  // 弹出对话框并等待其关闭
                  bool delete = await showDeleteConfirmDialog1();
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('确认删除');
                    // ... 删除文件
                  }
                },
              ),
              RaisedButton(
                child: Text('对话框 (列表少)'),
                onPressed: () {
                  changeLanguage();
                },
              ),
              RaisedButton(
                child: Text('对话框 (长列表)'),
                onPressed: () {
                  showListDialog();
                },
              ),
              RaisedButton(
                child: Text('自定义对话框'),
                onPressed: () async {
                  // 弹出对话框并等待其关闭
                  bool delete = await _showCustomDialog();
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('确认删除');
                    // ... 删除文件
                  }
                },
              ),
              RaisedButton(
                child: Text('对话框 2(复选框可点击)'),
                onPressed: () async {
                  // 弹出对话框并等待其关闭
                  bool delete = await showDeleteConfirmDialog2();
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('"同时删除子目录: $delete"');
                    // ... 删除文件
                  }
                },
              ),
              RaisedButton(
                child: Text('对话框 3(复选框可点击)'),
                onPressed: () async {
                  // 弹出对话框并等待其关闭
                  bool delete = await showDeleteConfirmDialog3();
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('"同时删除子目录: $delete"');
                    // ... 删除文件
                  }
                },
              ),
              RaisedButton(
                child: Text('对话框 4(复选框可点击)'),
                onPressed: () async {
                  // 弹出对话框并等待其关闭
                  bool delete = await showDeleteConfirmDialog4();
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('"同时删除子目录: $delete"');
                    // ... 删除文件
                  }
                },
              ),
              // 底部对话框
              RaisedButton(
                child: Text('底部列表对话框'),
                onPressed: () async {
                  var index = await _showModalBottomSheet();
                  print('$index');
                },
              ),
              // Loading框
              RaisedButton(
                child: Text('Loading框'),
                onPressed: () async {
                  showLoadingDialog();
                },
              ),

              // 日历选择 1
              RaisedButton(
                child: Text('日历选择 1'),
                onPressed: () async {
                  var date = await _showDatePicker1();
                  print('$date');
                },
              ),
              // 日历选择 2
              RaisedButton(
                child: Text('日历选择 2'),
                onPressed: () async {
                  var date = await _showDatePicker2();
                  print('$date');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 弹出对话框 1\
  /*
  const AlertDialog({
  Key key,
  this.title, //对话框标题组件
  this.titlePadding, // 标题填充
  this.titleTextStyle, //标题文本样式
  this.content, // 对话框内容组件
  this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0), //内容的填充
  this.contentTextStyle,// 内容文本样式
  this.actions, // 对话框操作按钮组
  this.backgroundColor, // 对话框背景色
  this.elevation,// 对话框的阴影
  this.semanticLabel, //对话框语义化标签(用于读屏软件)
  this.shape, // 对话框外形
})
   */
  Future<bool> showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text('提示'),
            content: Text('你确定要删除当前文件吗？想不想想不想想不想想不想选择啊'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              FlatButton(
                child: Text('删除'),
                onPressed: () {
                  // ... 执行删除操作
                  Navigator.of(context).pop(true);
                }, // 关闭对话框，并返回true
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> showDeleteConfirmDialog2() {
    withTree = false; // 默认复选框不选中
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(primaryColor: Colors.white),
          child: AlertDialog(
            title: Text('提示'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('您确定要删除当前文件吗？'),
                Row(
                  children: <Widget>[
                    Text('同时删除子目录？'),
                    DialogCheckBox(
                      value: withTree,
                      onChanged: (v) {
                        withTree = v;
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              FlatButton(
                child: Text('删除'),
                onPressed: () {
                  // ... 执行删除操作
                  Navigator.of(context).pop(true);
                }, // 关闭对话框，并返回true
              ),
            ],
          ),
        );
      },
    );
  }

  // 比对话框2更优、复用
  Future<bool> showDeleteConfirmDialog3() {
    withTree = false; // 默认复选框不选中
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(primaryColor: Colors.white),
          child: AlertDialog(
            title: Text('提示'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('您确定要删当前文件吗？'),
                Row(
                  children: <Widget>[
                    Text('同时删除子目录？'),
                    // 使用StatefulBuilder来构建StatefulWidget上下文
                    StatefulBuilder(
                      builder: (context, _setState) {
                        return Checkbox(
                          value: withTree,
                          onChanged: (v) {
                            _setState(() {
                              withTree = v;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              FlatButton(
                child: Text('删除'),
                onPressed: () {
                  // ... 执行删除操作
                  Navigator.of(context).pop(true);
                }, // 关闭对话框，并返回true
              ),
            ],
          ),
        );
      },
    );
  }

  // 比 2、3 更优解
  // 只需要更新复选框的状态，而此时的context我们用的是对话框的根context，所以会导致整个对话框UI组件全部rebuild，
  // 因此最好的做法是将context的“范围”缩小，也就是说只将Checkbox的Element标记为dirty
  Future<bool> showDeleteConfirmDialog4() {
    withTree = false; // 默认复选框不选中
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(primaryColor: Colors.white),
          child: AlertDialog(
            title: Text('提示'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('您确定要删除当前文件吗？'),
                Row(
                  children: <Widget>[
                    Text('同时删除子目录？'),
                    // 通过Builder来获得构建Checkbox的`context`，
                    // 这是一种常用的缩小`context`范围的方式
                    Builder(
                      builder: (context) {
                        return Checkbox(
                          value: withTree,
                          onChanged: (v) {
                            // 此时context为对话框UI的根Element，我们
                            // 直接将对话框UI对应的Element标记为dirty
                            (context as Element).markNeedsBuild();
                            withTree = v;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              FlatButton(
                child: Text('删除'),
                onPressed: () {
                  // ... 执行删除操作
                  Navigator.of(context).pop(withTree);
                }, // 关闭对话框，并返回true
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. SimpleDialog 它会展示一个列表，用于列表选择的场景
  Future changeLanguage() async {
    int i = await showDialog<int>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light(),
          child: SimpleDialog(
            title: Text('选择语言'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('中文简体'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('美国英语'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (i != null) {
      print('选择了：${i == 1 ? '中文简体' : '美国英语'}');
    }
  }

  // 3. Dialog
  Future showListDialog() async {
    int index = await showDialog<int>(
      context: context,
      builder: (context) {
        var child = Column(
          children: <Widget>[
            ListTile(title: Text('请选择')),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('$index'),
                    onTap: () => Navigator.of(context).pop(index),
                  );
                },
              ),
            ),
          ],
        );
        // return AlertDialog(content: child); // 会报错
        return Theme(
          data: ThemeData(primaryColor: Colors.white),
          child: Dialog(child: child),
        ); // == 下方效果
        // return UnconstrainedBox(
        //   constrainedAxis: Axis.vertical,
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(maxWidth: 280),
        //     child: Material(
        //       child: child,
        //       type: MaterialType.card,
        //     ),
        //   ),
        // );
      },
    );

    if (index != null) {
      print('选择了：$index');
    }
  }

  // 4. 自定义对话框
  Future<T> showCustomDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    final ThemeData themeData = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animtion, secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(
            builder: (context) {
              return themeData != null
                  ? Theme(data: themeData, child: pageChild)
                  : pageChild;
            },
          ),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87, // 自定义遮罩颜色
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransition,
    );
  }

  Widget _buildMaterialDialogTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  Future<bool> _showCustomDialog() {
    return showCustomDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text('提示'),
            content: Text('您��������������������������定要删除当前文件吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('删除'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
    );
  }

  // 其它类型的对话框
  // 底部菜单列表模态对话框
  Future<int> _showModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('$index'),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      },
    );
  }

  // showBottomSheet 该方法会从设备底部向上弹出一个全屏的菜单列表
  PersistentBottomSheetController<int> _showBottomSheet() {
    return showBottomSheet<int>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('$index'),
              onTap: () {
                print('$index');
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }

  // Loading框
  // 直接通过 showDialog + AlertDialog 来自定义
  Future<Void> showLoadingDialog() {
    showDialog(
      context: context,
      // barrierDismissible: false, // 点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text('正在加载，请稍候...'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 日历选择 1
  Future<DateTime> _showDatePicker1() {
    var dateNow = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: dateNow,
      lastDate: dateNow.add(
        Duration(days: 30), // 未来30天可选
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData(primaryColor: Colors.white),
          child: child,
        );
      },
    );
  }

  // 日历选择 2
  // iOS：showCupertinoModalPopup方法和CupertinoDatePicker控件来实现
  Future<DateTime> _showDatePicker2() {
    var dateNow = DateTime.now();
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 40.0,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      splashColor: Colors.lightBlueAccent,
                      onPressed: () {
                        setState(() => Navigator.of(context).pop());
                      },
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      child: Text(
                        '请选择时间',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    FlatButton(
                      splashColor: Colors.lightBlueAccent,
                      onPressed: () {
                        setState(() => Navigator.of(context).pop(dateNow));
                      },
                      child: Text(
                        '确定',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  minimumDate: dateNow,
                  maximumDate: dateNow.add(
                    Duration(days: 30),
                  ),
                  maximumYear: dateNow.year + 1,
                  onDateTimeChanged: (value) {
                    dateNow = value;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
