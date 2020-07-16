import 'package:flutter/material.dart';import 'sub_test_stateful_widget.dart';/// 创建有状态的测试组件class TestStatefulWidget extends StatefulWidget {  @override  _TestStatefulWidgetState createState() {    print('create state');    return _TestStatefulWidgetState();  }}/// 创建状态管理类，继承状态测试组件class _TestStatefulWidgetState extends State<TestStatefulWidget> {  /// 定义 state [count] 计算器  int count = 1;  /// 定义 state [name] 为当前描述字符串  String name = 'test';  @override  void initState() {    print('init state');    super.initState();  }    @override  void didChangeDependencies() {    print('did change dependencies');    super.didChangeDependencies();  }  @override  void didUpdateWidget(TestStatefulWidget oldWidget) {    count++;    print('did update widget');    super.didUpdateWidget(oldWidget);  }  @override  void deactivate() {    print('deactivate');    super.deactivate();  }  @override  void dispose() {    print('dispose');    super.dispose();  }  @override  void reassemble() {    print('reassemble');    super.reassemble();  }  @override  Widget build(BuildContext context) {    print('build');    return Column(      children: [        FlatButton(          child: Text('$name $count'), // 使用 Text 组件显示描述字符和当前计算          onPressed: () => this.changeStateName(), // 点击触发修改描述字符 state name        ),        // 加载子组件        SubTestStatefulWidget()      ],    );  }  /// 修改 state name  void changeStateName() {    setState(() {      print('set state');      this.name = 'flutter';    });  }}