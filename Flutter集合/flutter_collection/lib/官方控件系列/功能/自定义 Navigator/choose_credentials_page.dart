import 'package:flutter/material.dart';

class ChooseCredentialsPage extends StatelessWidget {
  final VoidCallback onSignUpComplete;

  const ChooseCredentialsPage({this.onSignUpComplete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSignUpComplete,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline4,
        child: Container(
          color: Colors.pinkAccent,
          alignment: Alignment.center,
          child: Text('Choose Credentials Page.'),
        ),
      ),
    );
  }
}
