import 'package:flutter/material.dart';

/// 具体的帖子图片
///
/// [articleImage]为帖子详情图片
class ArticleDetailImg extends StatelessWidget {
  /// 传入的帖子图片
  final String articleImage;

  /// 构造函数
  const ArticleDetailImg({Key key, this.articleImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Image.network(
        articleImage,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
