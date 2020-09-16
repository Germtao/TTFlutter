import 'package:flutter/material.dart';

class ParentAnimationDemo extends StatefulWidget {
  @override
  _ParentAnimationDemoState createState() => _ParentAnimationDemoState();
}

class _ParentAnimationDemoState extends State<ParentAnimationDemo> with SingleTickerProviderStateMixin {
  TextEditingController _nameController, _pwdController;

  Animation _animation, _childAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _pwdController = TextEditingController();

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _childAnimation = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
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
            transform: Matrix4.translationValues(_animation.value * width, .0, .0),
            child: AnimatedBuilder(
              animation: _childAnimation,
              builder: (context, child) {
                return Container(
                  height: _childAnimation.value * 3,
                  width: _childAnimation.value * 3,
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
                              color: Colors.white,
                              child: Text('登录'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
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
