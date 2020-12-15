import 'package:flutter/material.dart';

class TextSizeDemoPage extends StatefulWidget {
  @override
  _TextSizeDemoPageState createState() => _TextSizeDemoPageState();
}

class _TextSizeDemoPageState extends State<TextSizeDemoPage> {
  double textScaleFactor = 1;

  @override
  void initState() {
    super.initState();
  }

  _buildContainer() {
    return Container(
      color: Colors.blueGrey,
      margin: EdgeInsets.all(20),
      // 利用 Transform 偏移将对应权重部分位置
      child: Text(
        textSizeContent,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _buildAlign() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                if (textScaleFactor > 1) {
                  setState(() {
                    textScaleFactor--;
                  });
                }
              },
              color: Colors.redAccent,
              child: Text('-'),
            ),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  textScaleFactor++;
                });
              },
              color: Colors.greenAccent,
              child: Text('+'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: textScaleFactor),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TextSizeDemoPage'),
        ),
        body: Stack(
          children: [
            _buildContainer(),
            _buildAlign(),
          ],
        ),
      ),
    );
  }
}

const textSizeContent =
    "Today I was amazed to see the usually positive and friendly VueJS community descend into a bitter war. Two weeks ago Vue creator Evan You released a Request for Comment (RFC) for a new function-based way of writing Vue components in the upcoming Vue 3.0. Today a critical "
    "Reddit thread followed by similarly "
    "critical comments in a Hacker News thread caused a "
    "flood of developers to flock to the original RFC to "
    "voice their outrage, some of which were borderline abusive. "
    "It was claimed in various places that";
