import 'package:flutter/material.dart';
import 'package:flutter_collection/功能型控件/inherited_widget(数据共享)/share_data_widget.dart';

class ShareDataTestWidget extends StatefulWidget {
  @override
  ShareDataTestWidgetState createState() => ShareDataTestWidgetState();
}

class ShareDataTestWidgetState extends State<ShareDataTestWidget> {
  @override
  Widget build(BuildContext context) {
    // 使用InheritedWidget中的共享数据
    return Text(
      ShareDataWidget.of(context).data.toString(),
      style: TextStyle(color: Colors.black38, fontSize: 20.0),
    );

    // 如果_TestWidget的build方法中没有使用ShareDataWidget的数据，
    // 那么它的didChangeDependencies()将不会被调用，因为它并没有依赖ShareDataWidget
    // return Text('text');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用
    // 如果build中没有依赖InheritedWidget，则此回调不会被调用
    print("Dependencies change");
  }
}
