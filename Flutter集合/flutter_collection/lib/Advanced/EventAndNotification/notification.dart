import 'package:flutter/material.dart';

// 通知
class NotificationTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('通知'),
        ),
        // 指定监听通知的类型为滚动结束通知(ScrollEndNotification)
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            // switch (notification.runtimeType) {
            //   case ScrollStartNotification:
            //     print('-----开始滚动');
            //     break;
            //   case ScrollUpdateNotification:
            //     print('++++++正在滚动');
            //     break;
            //   case ScrollEndNotification:
            //     print('*******滚动停止');
            //     break;
            // }
            // 只会在滚动结束时才会触发此回调
            print(notification);
            return true;
          },
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(title: Text('$index'));
            },
          ),
        ),
      ),
    );
  }
}
