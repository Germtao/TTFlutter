import 'package:flutter/material.dart';

// 通知
class NotificationTestRoute extends StatefulWidget {
  @override
  _NotificationTestRouteState createState() => _NotificationTestRouteState();
}

class _NotificationTestRouteState extends State<NotificationTestRoute> {
  String _msg = '';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('通知')),
        body: customNotification(),
      ),
    );
  }

  Widget customNotification() {
    return NotificationListener<CustomNotification>(
      onNotification: (notification) {
        print(notification.msg);
        return false;
      },
      child: NotificationListener<CustomNotification>(
        onNotification: (notification) {
          setState(() {
            _msg += notification.msg + '  ';
          });
          return false;
        },
        child: childWidget(),
      ),
    );
  }

  Widget childWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // RaisedButton(
          //   onPressed: () => CustomNotification('Hi!').dispatch(context),
          //   child: Text('发送通知'),
          // ),
          Builder(
            builder: (context) {
              return RaisedButton(
                // 按钮点击时分发通知
                onPressed: () => CustomNotification('Hello!').dispatch(context),
                child: Text('发送通知'),
              );
            },
          ),
          Text(_msg),
        ],
      ),
    );
  }
}

// MARK: - 自定义通知
class CustomNotification extends Notification {
  CustomNotification(this.msg);
  final String msg;
}
