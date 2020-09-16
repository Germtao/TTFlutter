import 'package:flutter/material.dart';

class DelayedAnimationDemo extends StatefulWidget {
  @override
  _DelayedAnimationDemoState createState() => _DelayedAnimationDemoState();
}

class _DelayedAnimationDemoState extends State<DelayedAnimationDemo> with SingleTickerProviderStateMixin {
  TextEditingController _nameController, _pwdController;

  Animation _animationTitle, _animationTextField, _animationButton;
  AnimationController _animationController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _pwdController = TextEditingController();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2, milliseconds: 50));

    _animationTitle = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    _animationTextField = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animationButton = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 80.0),
                Transform(
                  transform: Matrix4.translationValues(_animationTitle.value * width, 0.0, .0),
                  child: Center(
                    child: Text(
                      '登录',
                      style: TextStyle(fontSize: 32.0),
                    ),
                  ),
                ),
                const SizedBox(height: 80.0),
                Transform(
                  transform: Matrix4.translationValues(_animationTextField.value * width, .0, .0),
                  child: _buildTextField(_nameController, '登录', false),
                ),
                Transform(
                  transform: Matrix4.translationValues(_animationTextField.value * width, .0, .0),
                  child: _buildTextField(_pwdController, '密码', true),
                ),
                const SizedBox(height: 40.0),
                Transform(
                  transform: Matrix4.translationValues(_animationButton.value * width, .0, .0),
                  child: ButtonBar(
                    children: [
                      RaisedButton(
                        onPressed: null,
                        color: Colors.white,
                        child: Text('登录'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, bool obscureText) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
