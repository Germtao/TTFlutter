import 'package:flutter/foundation.dart';
import 'package:flutter_github_app/common/utils/code_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import 'package:flutter_github_app/model/user_org.dart';

/// 用户组织数据库表
class UserOrgsDBProvider extends BaseDBProvider {
  final String name = 'UserOrgs';

  final String columnId = '_id';
  final String columnUserName = 'userName';
  final String columnData = 'data';

  int id;
  String userName;
  String data;

  UserOrgsDBProvider();

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnUserName text not null,
        $columnData text not null)
      ''';
  }

  Map<String, dynamic> toMap(String userName, String data) {
    Map<String, dynamic> map = {columnUserName: userName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserOrgsDBProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }

  Future _getProvider(Database db, String userName) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnUserName, columnData],
      where: '$columnUserName = ?',
      whereArgs: [userName],
    );
    if (maps.length > 0) {
      UserOrgsDBProvider provider = UserOrgsDBProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  /// 插入到数据库
  Future insert(String userName, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      await db.delete(name, where: '$columnUserName = ?', whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, dataMapString));
  }

  /// 获取用户组织列表数据
  Future<List<UserOrg>> getData(String userName) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      List<UserOrg> list = List();

      // 使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(UserOrg.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
