import 'package:flutter/material.dart';

/// Stack + Positioned例子
/// 通过绝对定位布局
class PositionedDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PositionedDemoPage'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(15),
        child: Stack(
          children: [
            MaterialButton(
              onPressed: () {},
              color: Colors.blue,
            ),
            Positioned(
              child: MaterialButton(
                onPressed: () {},
                color: Colors.greenAccent,
              ),
              left: MediaQuery.of(context).size.width / 2,
            ),
            Positioned(
              child: MaterialButton(
                onPressed: () {},
                color: Colors.yellow,
              ),
              left: MediaQuery.of(context).size.width / 5,
              top: MediaQuery.of(context).size.height / 4 * 3,
            ),
            Positioned(
              child: MaterialButton(
                onPressed: () {},
                color: Colors.redAccent,
              ),
              left: MediaQuery.of(context).size.width / 2 - Theme.of(context).buttonTheme.minWidth / 2,
              top: MediaQuery.of(context).size.height / 2 - MediaQuery.of(context).padding.top - kToolbarHeight,
            )
          ],
        ),
      ),
    );
  }
}
