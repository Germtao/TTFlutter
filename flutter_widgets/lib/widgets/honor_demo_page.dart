import 'package:flutter/material.dart';

/// 共享元素动画
class HonorDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HonorDemoPage'),
      ),
      body: Container(
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return HonorPage();
                },
                fullscreenDialog: true,
              ));
            },
            // Hero tag 共享
            child: Hero(
              tag: 'image',
              child: Image.asset(
                'images/cat.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HonorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          alignment: Alignment.center,
          child: Hero(
            tag: 'image',
            child: Image.asset(
              'images/cat.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ),
    );
  }
}
