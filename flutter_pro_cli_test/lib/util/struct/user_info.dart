/// 用户信息
///
/// {
///   "nickname" : "string",
///   "headerUrl" : "string",
///   "uid" : "string"
/// }
class StructUserInfo {
  /// 昵称
  final String nickName;

  /// 头像
  final String headerUrl;

  /// 用户id
  final String uid;

  // ignore: public_member_api_docs
  const StructUserInfo(this.uid, this.nickName, this.headerUrl);

  /// 将json数据转化为对象数据
  StructUserInfo.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String,
        nickName = json['nickName'] as String,
        headerUrl = json['headerUrl'] as String;

  /// 将对象转化为json数据
  static Map<String, dynamic> toJson(StructUserInfo userInfo) => {
        'uid': userInfo.uid,
        'nickName': userInfo.nickName,
        'headerUrl': userInfo.headerUrl
      };
}
