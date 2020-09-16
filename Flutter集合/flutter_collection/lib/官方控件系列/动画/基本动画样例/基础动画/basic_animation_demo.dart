import 'package:flutter/material.dart';

class BasicAnimationDemo extends StatefulWidget {
  @override
  _BasicAnimationDemoState createState() => _BasicAnimationDemoState();
}

class _BasicAnimationDemoState extends State<BasicAnimationDemo> with SingleTickerProviderStateMixin {
  TextEditingController _nameController, _pwdController;

  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _pwdController = TextEditingController();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
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
      animation: _animation,
      builder: (context, child) {
        return Scaffold(
          body: Transform(
            transform: Matrix4.translationValues(_animation.value * width, 0.0, 0.0),
            child: SafeArea(
              child: ListView(
                children: [
                  const SizedBox(height: 80.0),
                  Center(
                    child: Text(
                      '登录',
                      style: TextStyle(fontSize: 32.0),
                    ),
                  ),
                  const SizedBox(height: 80.0),
                  _buildTextField(_nameController, '账号', false),
                  _buildTextField(_pwdController, '密码', true),
                  const SizedBox(height: 40.0),
                  ButtonBar(
                    children: [
                      RaisedButton(
                        onPressed: null,
                        child: Text('登录'),
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
