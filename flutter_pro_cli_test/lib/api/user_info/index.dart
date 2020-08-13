import 'dart:convert';

import 'package:flutter_pro_cli_test/util/struct/user_info.dart';
import 'package:flutter_pro_cli_test/util/struct/api_ret_info.dart';
import 'package:flutter_pro_cli_test/util/tools/call_server.dart';

/// 获取用户接口信息
class ApiUserInfoIndex {
  /// 根据用户id拉取用户信息
  static Future<StructUserInfo> getOneById(String id) async {
    Map<String, dynamic> retJson = await CallServer.get('userInfo', {'id': id});

    StructApiRetInfo retInfo = StructApiRetInfo.fromJson(retJson);

    if (retInfo.ret != 0 || retInfo.ret == null) {
      return null;
    }

    StructUserInfo userInfo =
        StructUserInfo.fromJson(retInfo.data as Map<String, dynamic>);

    return userInfo;
  }

  /// 获取现有用户信息
  static Future<StructUserInfo> getSelfUserInfo() async {
    String jsonStr =
        '{"nickName":"test","uid":"3001","headerUrl":"http://image.biaobaiju.com/uploads/20180211/00/1518279967-IAnVyPiRLK.jpg"}';
    print('json length');
    print(jsonStr.length);
    int currentTime = DateTime.now().microsecondsSinceEpoch;
    final jsonInfo = json.decode(jsonStr) as Map<String, dynamic>;
    print('json parse time');
    print(DateTime.now().microsecondsSinceEpoch - currentTime);
    return StructUserInfo.fromJson(jsonInfo);
  }
}
