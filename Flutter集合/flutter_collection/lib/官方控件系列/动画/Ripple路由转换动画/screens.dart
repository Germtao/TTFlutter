import 'package:flutter/material.dart';
import 'navigate_button.dart';

class FirstScreenRippleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ripple First Screen.'),
      ),
      body: Center(
        child: NavigateButton(
          nextScreen: SecondScreenRippleDemo(),
          color: Colors.blueAccent,
          splashColor: Colors.blueAccent,
        ),
      ),
      floatingActionButton: NavigateButton(
        nextScreen: SecondScreenRippleDemo(),
        color: Colors.white,
        splashColor: Colors.white,
        iconColor: Colors.black,
        heroTag: 'blue',
        rangeFactor: 2.4,
      ),
    );
  }
}

class SecondScreenRippleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ripple Second Screen.'),
      ),
    );
  }
}
