import 'package:flutter/material.dart';

/// 一个抽象类，为该类提供一些常用的生成器
/// 字符实体
///
/// * [containerized]: 将字符放入动画容器中的生成器。
/// * [circle]: 将字符放在圈子中的生成器。
/// * [rectangle]: 将 char 放在矩形中的生成器。
/// * [lightCircle]: 把 char 放在浅色圆圈中的生成器。
/// * [darkCircle]: 把 char 放在深色圆圈中的生成器。
/// * [lightRectangle]: 将字符放在浅色矩形中的生成器。
/// * [darkRectangle]: 将字符放在深色矩形中的生成器。
abstract class CodeInputBuilders {
  /// 在动画容器中构建输入
  static CodeInputBuilder containerized({
    Duration animationDuration = const Duration(milliseconds: 50),
    @required Size totalSize,
    @required Size emptySize,
    @required Size filledSize,
    @required BoxDecoration emptyDecoration,
    @required BoxDecoration filledDecoration,
    @required TextStyle emptyTextStyle,
    @required TextStyle filledTextStyle,
  }) {
    return (bool hasFocus, String char) => Container(
          width: totalSize.width,
          height: totalSize.height,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            decoration: char.isEmpty ? emptyDecoration : filledDecoration,
            width: char.isEmpty ? emptySize.width : filledSize.width,
            height: char.isEmpty ? emptySize.height : filledSize.height,
            alignment: Alignment.center,
            child: Text(
              char,
              style: char.isEmpty ? emptyTextStyle : filledTextStyle,
            ),
          ),
        );
  }

  /// 在圆内构建 input
  static CodeInputBuilder circle({
    double totalRadius = 30.0,
    double emptyRadius = 10.0,
    double filledRadius = 25.0,
    @required Border border,
    @required Color color,
    @required TextStyle textStyle,
  }) {
    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      border: border,
      color: color,
    );

    return containerized(
      totalSize: Size.fromRadius(totalRadius),
      emptySize: Size.fromRadius(emptyRadius),
      filledSize: Size.fromRadius(filledRadius),
      emptyDecoration: decoration,
      filledDecoration: decoration,
      emptyTextStyle: textStyle.copyWith(fontSize: 0.0),
      filledTextStyle: textStyle,
    );
  }

  /// 在矩形内构建 input
  static CodeInputBuilder rectangle({
    Size totalSize = const Size(50.0, 60.0),
    Size emptySize = const Size(20.0, 20.0),
    Size filledSize = const Size(40.0, 60.0),
    BorderRadius borderRadius = BorderRadius.zero,
    @required Border border,
    @required Color color,
    @required TextStyle textStyle,
  }) {
    final decoration = BoxDecoration(
      borderRadius: borderRadius,
      border: border,
      color: color,
    );

    return containerized(
      totalSize: totalSize,
      emptySize: emptySize,
      filledSize: filledSize,
      emptyDecoration: decoration,
      filledDecoration: decoration,
      emptyTextStyle: textStyle.copyWith(fontSize: 0.0),
      filledTextStyle: textStyle,
    );
  }

  /// 在一个浅色圆圈内构建 input
  static CodeInputBuilder lightCircle({
    double totalRadius = 30.0,
    double emptyRadius = 10.0,
    double filledRadius = 25.0,
  }) {
    return circle(
      totalRadius: totalRadius,
      emptyRadius: emptyRadius,
      filledRadius: filledRadius,
      border: Border.all(color: Colors.white, width: 2.0),
      color: Colors.white10,
      textStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  /// 在一个深色圆圈内构建 input
  static CodeInputBuilder darkCircle({
    double totalRadius = 30.0,
    double emptyRadius = 10.0,
    double filledRadius = 25.0,
  }) {
    return circle(
      totalRadius: totalRadius,
      emptyRadius: emptyRadius,
      filledRadius: filledRadius,
      border: Border.all(color: Colors.black, width: 2.0),
      color: Colors.black12,
      textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  /// 在浅矩形内构建 input
  static CodeInputBuilder lightRectangle({
    Size totalSize = const Size(50.0, 60.0),
    Size emptySize = const Size(20.0, 20.0),
    Size filledSize = const Size(40.0, 60.0),
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return rectangle(
      totalSize: totalSize,
      emptySize: emptySize,
      filledSize: filledSize,
      borderRadius: borderRadius,
      border: Border.all(color: Colors.white, width: 2.0),
      color: Colors.white10,
      textStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  static CodeInputBuilder staticRectangle({
    Size totalSize = const Size(60.0, 60.0),
    Size emptySize = const Size(40.0, 40.0),
    Size filledSize = const Size(40.0, 40.0),
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return rectangle(
      totalSize: totalSize,
      emptySize: emptySize,
      filledSize: filledSize,
      borderRadius: borderRadius,
      border: Border.all(color: Colors.white, width: 1.0),
      color: Colors.transparent,
      textStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  /// 在深矩形内构建 input
  static CodeInputBuilder darkRectangle({
    Size totalSize = const Size(50.0, 60.0),
    Size emptySize = const Size(20.0, 20.0),
    Size filledSize = const Size(40.0, 60.0),
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return rectangle(
      totalSize: totalSize,
      emptySize: emptySize,
      filledSize: filledSize,
      borderRadius: borderRadius,
      border: Border.all(color: Colors.black, width: 2.0),
      color: Colors.black12,
      textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }
}

typedef CodeInputBuilder = Widget Function(bool hasFocus, String char);
