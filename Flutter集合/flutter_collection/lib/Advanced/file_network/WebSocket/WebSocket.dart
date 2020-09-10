import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketTestRoute extends StatefulWidget {
  WebSocketTestRoute({Key key}) : super(key: key);

  @override
  _WebSocketTestRouteState createState() => _WebSocketTestRouteState();
}

class _WebSocketTestRouteState extends State<WebSocketTestRoute> {
  TextEditingController _controller = new TextEditingController();
  IOWebSocketChannel channel;
  String _text = "";

  @override
  void initState() {
    channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket(内容回显)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // 网络不通
                  _text = '网络不通';
                } else if (snapshot.hasData) {
                  _text = 'echo: ' + snapshot.data;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(_text),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Send Message',
        child: Icon(Icons.add),
        onPressed: _sendMessage,
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }
}
