import 'package:flutter_pro_cli_test/api/user_info/index.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/util/struct/user_info.dart';

/// 获取内容详情接口
class ApiContentIndex {
  StructContentDetail getOneById(String id) {
    StructContentDetail detailInfo = StructContentDetail(
      '1001',
      'hello test',
      'summary',
      'detail info ${id}',
      '1001',
      1,
      2,
      'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png',
    );
  }
}
