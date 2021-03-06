import 'package:flutter_pro_cli_test/model/new_message_model.dart';
import 'package:flutter_pro_cli_test/util/struct/api_ret_info.dart';
import 'package:flutter_pro_cli_test/util/tools/call_server.dart';

/// 获取用户消息相关
class ApiUserInfoMessage {
  /// 获取未读消息数
  static Future<void> getUnreadMessageNum(
      NewMessageModel newMessageModel) async {
    Map<String, dynamic> retJson = await CallServer.get('newMessage');
    print("获取未读消息数 $retJson");
    if (retJson == null || retJson['ret'] == false) {
      return;
    }

    StructApiRetInfo retInfo = StructApiRetInfo.fromJson(retJson);

    if (retInfo.ret != 0 || retInfo.data == null) {
      return;
    }

    Map dataInfo = retInfo.data as Map;

    if (dataInfo == null || dataInfo['unread_num'] == null) {
      return;
    }

    newMessageModel.setNewMessageNum(dataInfo['unread_num'] as int);
  }
}
