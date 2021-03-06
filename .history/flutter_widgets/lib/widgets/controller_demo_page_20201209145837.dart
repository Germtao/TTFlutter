import 'package:flutter/material.dart';

/*
 * 在 Flutter 中有很多内置的 Controller
 * 大部分内置控件都可以通过 Controller 设置和获取控件参数
 * 比如 TextField 的 TextEditingController
 * 比如 ListView  的 ScrollController
 * 一般想对控件做 OOXX 的事情，先找个 Controller 就对了 
 */
class ControllerDemoPage extends StatelessWidget {
  final TextEditingController controller = new TextEditingController(text: "init Text");

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
