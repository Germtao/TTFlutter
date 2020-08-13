import 'dart:convert';

import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/util/struct/api_ret_info.dart';
import 'package:flutter_pro_cli_test/util/tools/call_server.dart';

/// 获取内容详情接口
class ApiContentIndex {
  /// 根据内容id拉取内容详情
  Future<StructContentDetail> getOneById(String id) async {
    Map<String, dynamic> retJson = await CallServer.get('userInfo', {'id': id});
    StructApiRetInfo retInfo = StructApiRetInfo.fromJson(retJson);

    if (retInfo.ret != 0 || retInfo.ret == null) {
      return null;
    }

    StructContentDetail contentDetail =
        StructContentDetail.fromJson(retInfo.data as Map<String, dynamic>);

    return contentDetail;
  }

  /// 拉取用户内容推荐帖子列表
  Future<StructApiContentListRetInfo> getRecommendList([lastId = null]) async {
    if (lastId != null) {
      Map<String, dynamic> retJson =
          await CallServer.get('recommendListNext', {lastId: lastId});

      return StructApiContentListRetInfo.fromJson(retJson);
    } else {
      Map<String, dynamic> retJson = await CallServer.get('recommendList');
      return StructApiContentListRetInfo.fromJson(retJson);
    }
  }

  /// 拉取用户关注的帖子列表
  Future<StructApiContentListRetInfo> getFollowList([lastId = null]) async {
    if (lastId != null) {
      Map<String, dynamic> retJson =
          await CallServer.get('followList', {lastId: lastId});
      return StructApiContentListRetInfo.fromJson(retJson);
    } else {
      Map<String, dynamic> retJson = await CallServer.get('followListNext');
      return StructApiContentListRetInfo.fromJson(retJson);
    }
  }
}
