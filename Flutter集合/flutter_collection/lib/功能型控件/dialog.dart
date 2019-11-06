import 'dart:ffi';

import 'package:flutter/material.dart';

// 对话框
class DialogTestRoute extends StatelessWidget {
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
                  bool delete = await showDeleteConfirmDialog1(context);
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('确认删除');
                    // ... 删除文件
                  }
                },
              ),
              RaisedButton(
                child: Text('对话框 2'),
                onPressed: () {
                  changeLanguage(context);
                },
              ),
              RaisedButton(
                child: Text('对话框 3(复选框可点击)'),
                onPressed: () {
                  showListDialog(context);
                },
              ),
              RaisedButton(
                child: Text('自定义对话框'),
                onPressed: () async {
                  // 弹出对话框并等待其关闭
                  bool delete = await _showCustomDialog(context);
                  if (delete == null) {
                    print('取消删除');
                  } else {
                    print('确认删除');
                    // ... 删除文件
                  }
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
  Future<bool> showDeleteConfirmDialog1(BuildContext context) {
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

  // 2. SimpleDialog 它会展示一个列表，用于列表选择的场景
  Future changeLanguage(BuildContext context) async {
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
  Future showListDialog(BuildContext context) async {
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
        return Dialog(child: child); // == 下方效果
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

  Future<bool> _showCustomDialog(BuildContext context) {
    return showCustomDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text('提示'),
            content: Text('您确定要删除当前文件吗？'),
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
}
