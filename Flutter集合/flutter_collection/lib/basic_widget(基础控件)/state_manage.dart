import 'package:flutter/material.dart';

// 状态管理
class StateManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('状态管理'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Widget管理自身状态',
                style: TextStyle(color: Colors.redAccent),
              ),
              color: Colors.green[200],
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TapBoxA(),
              )),
            )
          ],
        ),
      ),
    );
  }
}

// Widget管理自身状态
class TapBoxA extends StatefulWidget {
  @override
  _TapBoxAState createState() => _TapBoxAState();
}

class _TapBoxAState extends State<TapBoxA> {
  bool _active = false; // 确定盒子的当前颜色

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget管理自身状态'),
      ),
      body: GestureDetector(
        onTap: _handleTap,
        child: Center(
          child: Container(
            child: Center(
              child: Text(
                _active ? 'Active' : 'Inactive',
                style: TextStyle(fontSize: 32.0, color: Colors.white),
              ),
            ),
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(
              color: _active ? Colors.lightGreen[700] : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
