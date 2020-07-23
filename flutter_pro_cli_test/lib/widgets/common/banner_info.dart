import 'package:flutter/material.dart';

class BannerInfo extends StatelessWidget {
  /// banner image
  final String bannerImage;

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
