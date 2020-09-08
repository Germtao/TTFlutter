import 'package:flutter/material.dart';

/// banner 展示组件
///
/// 只需要传入需要展示的[bannerImage]
class BannerInfo extends StatelessWidget {
  /// banner image
  final String bannerImage;

  /// 构造函数
  const BannerInfo({Key key, this.bannerImage}) : super(key: key);

  /// 组件
  Widget getWidget(BuildContext context) {
    return Row(
      children: [
        Image.network(
          bannerImage,
          width: MediaQuery.of(context).size.width,
          height: 100,
          fit: BoxFit.cover,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getWidget(context);
  }
}
