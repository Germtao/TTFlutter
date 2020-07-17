import 'package:flutter/material.dart';import 'package:flutter_lagou_demo/test/redux/states/name_states.dart';import 'package:flutter_redux/flutter_redux.dart';import 'package:redux/redux.dart';class ReduxWelcome extends StatelessWidget {  /// store  final Store store;  ReduxWelcome({Key key, this.store}) : super(key: key);  @override  Widget build(BuildContext context) {    print('redux welcome build.');    return StoreConnector<NameStates, String>(      converter: (store) => store.state.name.toString(),      builder: (context, name) {        return Text('欢迎 $name');      },    );  }}