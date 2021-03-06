import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/user.dart';

/// 点赞的仓库表
class RepositoryStarDBProvider extends BaseDBProvider {
  final String name = 'RepositoryStar';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnData = 'data';

  int id;
  String fullName;
  String data;

  RepositoryStarDBProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryStarDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnData text not null)
      ''';
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnData],
      where: '$columnFullName = ?',
      whereArgs: [fullName],
    );
    return maps.length > 0 ? RepositoryStarDBProvider.fromMap(maps.first) : null;
  }

  /// 插入到数据库
  Future insert(String fullName, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db.delete(name, where: '$columnFullName = ?', whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, dataMapString));
  }

  /// 获取点赞的仓库列表数据
  Future<List<User>> getRepositoryStar(String fullName) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<User> list = List();

      // 使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(User.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
