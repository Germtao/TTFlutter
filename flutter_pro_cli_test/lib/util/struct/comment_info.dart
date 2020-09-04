import 'user_info.dart';

/// 评论信息
///
/// {
///   "userInfo" : "StructUserInfo",
///   "comment" : "string"
/// }
class StructCommentInfo {
  /// 用户信息
  final StructUserInfo userInfo;

  /// 评论
  final String comment;

  const StructCommentInfo(this.userInfo, this.comment);

  /// 将json数据转化为对象数据
  StructCommentInfo.fromJson(Map<String, dynamic> json)
      : comment = json['comment'] as String,
        userInfo =
            StructUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>);

  /// 将对象转化为json数据
  static Map<String, dynamic> toJson(StructCommentInfo commentInfo) => {
        'comment': commentInfo.comment,
        'userInfo': StructUserInfo.toJson(commentInfo.userInfo),
      };
}
