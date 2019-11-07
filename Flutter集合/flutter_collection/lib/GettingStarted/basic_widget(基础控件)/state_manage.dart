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
            ),
            RaisedButton(
              child: Text(
                '父Widget管理子Widget的状态',
                style: TextStyle(color: Colors.black87),
              ),
              color: Colors.purple[200],
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ParentWidget(),
              )),
            ),
            RaisedButton(
              child: Text(
                '混合状态管理',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ParentWidgetC(),
              )),
            ),
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

// 父Widget管理子Widget的状态
// TapboxB通过回调将其状态导出到其父组件，状态由父组件管理
class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('父Widget管理子Widget的状态'),
      ),
      body: Center(
        child: TapBoxB(
          active: _active,
          onChanged: _handleTapboxChanged,
        ),
      ),
    );
  }
}

class TapBoxB extends StatelessWidget {
  TapBoxB({Key key, this.active: false, @required this.onChanged})
      : super(key: key);
  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

// 混合状态管理
class ParentWidgetC extends StatefulWidget {
  @override
  _ParentWidgetCState createState() => _ParentWidgetCState();
}

class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false; // 管理盒子点击状态

  void _handleTapBoxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('混合管理状态'),
      ),
      body: Center(
        child: TapBoxC(
          active: _active,
          onChanged: _handleTapBoxChanged,
        ),
      ),
    );
  }
}

class TapBoxC extends StatefulWidget {
  TapBoxC({Key key, this.active: false, @required this.onChanged})
      : super(key: key);
  final bool active;
  final ValueChanged<bool> onChanged;
  @override
  _TapBoxCState createState() => _TapBoxCState();
}

class _TapBoxCState extends State<TapBoxC> {
  bool _highlight = false; // 管理盒子内部点击高亮状态

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown, // 处理按下事件
      onTapUp: _handleTapUp, // 处理抬起事件
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        child: Center(
          child: Text(widget.active ? 'Active' : 'Inactive',
              style: TextStyle(fontSize: 32.0, color: Colors.white)),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? Border.all(color: Colors.teal[700], width: 10.0)
              : null,
        ),
      ),
    );
  }
}
