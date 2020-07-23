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
}
