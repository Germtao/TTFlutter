import 'package:flutter/material.dart';

class RichTextDemoPage2 extends StatefulWidget {
  @override
  _RichTextDemoPage2State createState() => _RichTextDemoPage2State();
}

class _RichTextDemoPage2State extends State<RichTextDemoPage2> {
  double size = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RichTextDemoPage2'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                size += 10;
              });
            },
            icon: Icon(Icons.add_circle_outline),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                size -= 10;
              });
            },
            icon: Icon(Icons.remove_circle_outline),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Builder(
        builder: (context) {
          return Center(
            child: Text.rich(TextSpan(children: <InlineSpan>[
              TextSpan(text: 'Fluuter is'),
              WidgetSpan(
                child: SizedBox(
                  width: 120,
                  height: 50,
                  child: Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text('Hello World.'),
                    ),
                  ),
                ),
              ),
              WidgetSpan(
                  child: SizedBox(
                width: size > 0 ? size : 0,
                height: size > 0 ? size : 0,
                child: Image.asset(
                  'images/cat.png',
                  fit: BoxFit.cover,
                ),
              )),
              TextSpan(text: 'the best!')
            ])),
          );
        },
      ),
    );
  }

  show(context, text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You pressed snackbar\'s action.'),
          ));
        },
      ),
    ));
  }
}
