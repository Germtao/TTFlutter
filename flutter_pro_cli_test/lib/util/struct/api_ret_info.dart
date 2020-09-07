import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';

/// api 拉取content list返回结构
///
/// {
///   "ret" : 0,
///   "message" : "success",
///   "hasMore" : true,
///   "lastId" : null,
/// }
class StructApiContentListRetInfo {
  /// 表示返回的状态码，0 表示成功
  final int ret;

  /// 返回的提示信息
  final String message;

  /// 是否还有更多
  final bool hasMore;

  /// 翻页标识, 最后一个id
  final String lastId;

  /// 具体的content list
  final List<StructContentDetail> data;

  const StructApiContentListRetInfo(
      this.ret, this.message, this.hasMore, this.lastId, this.data);

  /// 将json数据转化为对象数据
  StructApiContentListRetInfo.fromJson(Map<String, dynamic> json)
      : ret = json['ret'] as int,
        message = json['message'] as String,
        hasMore = json['hasMore'] as bool,
        lastId = json['lastId'] as String,
        data = getContentDetailList(json['data'] as List);

  /// 将对象转化为json数据
  static Map<String, dynamic> toJson(StructApiContentListRetInfo retInfo) => {
        'ret': retInfo.ret,
        'message': retInfo.message,
        'hasMore': retInfo.hasMore,
        'lastId': retInfo.lastId,
        'data': retInfo.data
            .map((contentInfo) => StructContentDetail.toJson(contentInfo))
      };

  /// 数据转化
  static List<StructContentDetail> getContentDetailList(List dataList) {
    List<StructContentDetail> retList = [];
    dataList.forEach((element) {
      Map<String, dynamic> contentDetail = element as Map<String, dynamic>;
      retList.add(StructContentDetail.fromJson(contentDetail));
    });
    return retList;
  }
}

/// 通用接口返回数据结构
class StructApiRetInfo {
  final int ret;
  final String message;
  final data;

  StructApiRetInfo.newMessage(this.ret, this.message, this.data);

  /// 将对象转化为 json 数据
  static Map<String, dynamic> toJson(StructApiRetInfo retInfo) => {
        'ret': retInfo.ret,
        'message': retInfo.message,
        'data': retInfo.data,
      };

  // 将json数据转化为对象数据
  StructApiRetInfo.fromJson(Map<String, dynamic> json)
      : ret = json['ret'] as int,
        message = json['message'] as String,
        data = json['data'];
}
