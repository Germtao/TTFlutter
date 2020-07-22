import 'user_info.dart';

class StructContentDetail {
  /// 帖子 id
  final String id;

  /// 标题
  final String title;

  /// 简要
  final String summary;

  /// 主要内容
  final String detailInfo;

  /// 作者 id
  final String uid;

  /// 用户信息
  final StructUserInfo userInfo;

  /// 帖子文章图片
  final String articleImage;

  /// 点赞数
  final int likeNum;

  /// 评论数
  final int commentNum;

  const StructContentDetail(this.id, this.title, this.summary, this.detailInfo,
      this.uid, this.likeNum, this.commentNum, this.articleImage,
      {this.userInfo});
}
