import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import 'package:flutter_github_app/model/user.dart';
import 'package:flutter_github_app/common/utils/code_utils.dart';

/// 用户表
class UserInfoDBProvider extends BaseDBProvider {
  final String name = 'UserInfo';

  final String columnId = '_id';
  final String columnUserName = 'userName';
  final String columnData = 'data';

  int id;
  String userName;
  String data;

  UserInfoDBProvider();

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

  UserInfoDBProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }

  /// 获取 user provider
  Future _getUserProvider(Database db, String userName) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnUserName, columnData],
      where: '$columnUserName = ?',
      whereArgs: [userName],
    );

    if (maps.length > 0) {
      UserInfoDBProvider provider = UserInfoDBProvider.fromMap(maps.first);
      return provider;
    }

    return null;
  }

  /// 插入到数据库
  Future insert(String userName, String eventMapString) async {
    Database db = await getDatabase();
    var userProvider = await _getUserProvider(db, userName);
    if (userProvider != null) {
      await db.delete(name, where: '$columnUserName = ?', whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, eventMapString));
  }

  /// 获取用户信息
  Future<User> getUserInfo(String userName) async {
    Database db = await getDatabase();
    var userProvider = await _getUserProvider(db, userName);
    if (userProvider != null) {
      // 使用 compute 的 Isolate 优化 json decode
      var mapData = await compute(CodeUtils.decodeMapResult, userProvider.data as String);
      return User.fromJson(mapData);
    }
    return null;
  }
}
