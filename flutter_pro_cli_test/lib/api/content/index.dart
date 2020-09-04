import 'dart:core';

import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/util/struct/api_ret_info.dart';
import 'package:flutter_pro_cli_test/util/tools/call_server.dart';

/// 获取内容详情接口
class ApiContentIndex {
  /// 根据内容id拉取内容详情
  static Future<StructContentDetail> getOneById(String id) async {
    if (id == null || id == '') {
      return null;
    }

    Map<String, dynamic> retJson =
        await CallServer.get('detailInfo', {'id': id});
    StructApiRetInfo retInfo = StructApiRetInfo.fromJson(retJson);

    if (retInfo.ret != 0 || retInfo.data == null) {
      return null;
    }

    StructContentDetail contentDetail =
        StructContentDetail.fromJson(retInfo.data as Map<String, dynamic>);

    return contentDetail;
  }

  /// 拉取用户内容推荐帖子列表
  static Future<StructApiContentListRetInfo> getRecommendList(
      [lastId = null]) async {
    if (lastId != null) {
      Map<String, dynamic> retJson =
          await CallServer.get('recommendListNext', {lastId: lastId});

      if (retJson == null || retJson['ret'] == false) {
        return null;
      }

      return StructApiContentListRetInfo.fromJson(retJson);
    } else {
      Map<String, dynamic> retJson = await CallServer.get('recommendList');
      return StructApiContentListRetInfo.fromJson(retJson);
    }
  }

  /// 拉取用户关注的帖子列表
  static Future<StructApiContentListRetInfo> getFollowList(
      [lastId = null]) async {
    if (lastId != null) {
      Map<String, dynamic> retJson =
          await CallServer.get('followListNext', {lastId: lastId});
      return StructApiContentListRetInfo.fromJson(retJson);
    } else {
      Map<String, dynamic> retJson = await CallServer.get('followList');
      return StructApiContentListRetInfo.fromJson(retJson);
    }
  }

  /// 拉取用户的贴子列表
  static Future<StructApiContentListRetInfo> getUserContentList(String userId,
      [lastId = null]) async {
    if (lastId != null) {
      Map<String, dynamic> retJson = await CallServer.get(
          'userContentList', {userId: userId, lastId: lastId});
      return StructApiContentListRetInfo.fromJson(retJson);
    } else {
      Map<String, dynamic> retJson =
          await CallServer.get('userContentList', {userId: userId});
      return StructApiContentListRetInfo.fromJson(retJson);
    }
  }
}
