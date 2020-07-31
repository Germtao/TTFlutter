/// 用户信息
///
/// {
///   "nickname" : "string",
///   "headerUrl" : "string",
///   "uid" : "string"
/// }
class StructUserInfo {
  /// 昵称
  final String nickname;

  /// 头像
  final String avatar;

  /// uid
  final String uid;

  const StructUserInfo(this.uid, this.nickname, this.avatar);

  /// 将json数据转化为对象数据
  StructUserInfo.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String,
        nickname = json['nickname'] as String,
        avatar = json['avatar'] as String;

  /// 将对象转化为json数据
  static Map<String, dynamic> toJson(StructUserInfo userInfo) => {
        'uid': userInfo.uid,
        'nickname': userInfo.nickname,
        'avatar': userInfo.avatar
      };
}
