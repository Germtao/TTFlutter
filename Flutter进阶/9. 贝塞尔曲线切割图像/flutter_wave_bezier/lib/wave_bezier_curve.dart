import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: BottomClipper(), // 裁切的路径
            child: Container(
              color: Colors.deepOrangeAccent,
              height: 250.0,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50.0);
    var firstStartPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50.0);
    var dx1 = firstStartPoint.dx;
    var dy1 = firstStartPoint.dy;
    var dx2 = firstEndPoint.dx;
    var dy2 = firstEndPoint.dy;
    path.quadraticBezierTo(dx1, dy1, dx2, dy2);
    path.lineTo(size.width, size.height - 50.0);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
