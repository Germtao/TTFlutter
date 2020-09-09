import 'dart:convert';

import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

import 'package:xml2json/xml2json.dart';

/// 获取用户接口信息
class ApiXmlUserInfoIndex {
  /// 获取自己的个人信息
  static Future<StructUserInfo> getSelfUserInfo() async {
    // 模拟 xml 假数据
    final userInfoXml = '''<?xml version="1.0"?>
    <userInfo>
      <nickName>test</nickName>
      <uid>3001</uid>
      <avatar>http://image.biaobaiju.com/uploads/20180211/00/1518279967-IAnVyPiRLK.jpg</avatar>
    </userInfo>''';

    // 记录当前时间
    int currentTime = DateTime.now().microsecondsSinceEpoch;
    Xml2Json xml2json = Xml2Json();
    xml2json.parse(userInfoXml);

    // 转化xml数据
    final userInfoStr = xml2json.toGData();
    print('xml length');
    print(userInfoStr.length);

    int jsonStartTime = DateTime.now().microsecondsSinceEpoch;
    final userInfo = json.decode(userInfoStr);

    // 打印解析 json 时间
    print('json decode time:');
    print(DateTime.now().microsecondsSinceEpoch - jsonStartTime);

    // 打印整体解析时间
    print('xml decode time:');
    print(DateTime.now().microsecondsSinceEpoch - currentTime);

    return StructUserInfo(
      userInfo['userInfo']['uid']['\$t'] as String,
      userInfo['userInfo']['nickName']['\$t'] as String,
      userInfo['userInfo']['avatar']['\$t'] as String,
    );
  }
}
