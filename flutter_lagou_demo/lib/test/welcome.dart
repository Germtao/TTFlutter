import 'package:flutter/material.dart';import 'inherited_widget_test.dart';/// 欢迎人展示组件class Welcome extends StatelessWidget {  @override  Widget build(BuildContext context) {    print('welcome build');    final name = context.dependOnInheritedWidgetOfExactType<NameInheritedWidget>(aspect: NameInheritedWidget).name;    return Text('欢迎 $name');  }}