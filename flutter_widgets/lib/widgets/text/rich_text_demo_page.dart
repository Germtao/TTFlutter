import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../rich/real_rich_text.dart';

class RichTextDemoPage extends StatefulWidget {
  @override
  _RichTextDemoPageState createState() => _RichTextDemoPageState();
}

class _RichTextDemoPageState extends State<RichTextDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RichTextDemoPage'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Builder(
          builder: (context) {
            return Center(
              child: _realRickText(context),
            );
          },
        ),
      ),
    );
  }

  _realRickText(context) {
    return RealRichText([
      TextSpan(
        text: 'A Text Link.',
        style: TextStyle(fontSize: 14, color: Colors.red),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            show(context, 'Link Clicked.');
          },
      ),
      ImageSpan(
        AssetImage('images/cat.png'),
        imageWidth: 24,
        imageHeight: 24,
      ),
      ImageSpan(
        AssetImage('images/cat.png'),
        imageWidth: 24,
        imageHeight: 24,
        margin: EdgeInsets.symmetric(horizontal: 10),
      ),
      TextSpan(
        text: '嘿嘿嘿',
        style: TextStyle(fontSize: 14, color: Colors.yellow),
      ),
      TextSpan(
        text: '@Somebody',
        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            show(context, 'Link Clicked!');
          },
      ),
      TextSpan(
        text: '#ReakRickText#',
        style: TextStyle(fontSize: 14, color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            show(context, 'Link clicked...');
          },
      ),
      TextSpan(
        text: 'showing a bigger image.',
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
      ImageSpan(
        AssetImage('images/cat.png'),
        imageWidth: 24,
        imageHeight: 24,
        margin: EdgeInsets.symmetric(horizontal: 5),
      ),
      TextSpan(
        text: 'add seems working perfect...',
        style: TextStyle(fontSize: 14, color: Colors.black),
      )
    ]);
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
