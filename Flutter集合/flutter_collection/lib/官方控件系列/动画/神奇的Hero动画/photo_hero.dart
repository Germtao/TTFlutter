import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

/// 当[HeroAnimation]作为app的home属性提供时，
/// [MaterialApp]会隐式推送起始路径。
/// [InkWell]包装图像，使得向[源]和[目标][Hero]添加轻击手势变得非常简单。
/// 使用透明颜色定义“材质”窗口小部件可使图像在飞往目标时“弹出”背景。
/// [SizedBox]指定动画开始和结束时[Hero]的大小。
/// 将图像的fit属性设置为[BoxFit.contain]，可确保图像在过渡期间尽可能大，
/// 而不会更改其纵横比。
class PhotoSourceHeroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('源 Photo Hero Page'),
      ),
      body: Center(
        child: PhotoHero(
          photo: 'http://pic1.win4000.com/wallpaper/e/537ebd9b60603.jpg',
          width: 300.0,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotoTargetHeroPage())),
        ),
      ),
    );
  }
}

class PhotoTargetHeroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('目标 Photo Hero Page'),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.topLeft,
        child: PhotoHero(
          photo: 'http://pic1.win4000.com/wallpaper/e/537ebd9b60603.jpg',
          width: 100.0,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class PhotoHero extends StatelessWidget {
  final String photo;
  final VoidCallback onTap;
  final double width;

  const PhotoHero({Key key, this.photo, this.width, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
