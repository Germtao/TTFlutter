import 'package:flutter/material.dart';
import '../../common/style/style.dart';

/// 头像 Icon
class UserIconWidget extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  UserIconWidget({
    this.image,
    this.onPressed,
    this.width = 30.0,
    this.height = 30.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: padding ?? const EdgeInsets.only(left: 5.0, top: 4.0, right: 5.0),
      constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
      child: ClipOval(
        child: FadeInImage(
          placeholder: AssetImage(TTIcons.DEFAULT_USER_ICON),
          image: NetworkImage(image),
          fit: BoxFit.fitWidth,
          width: width,
          height: height,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
