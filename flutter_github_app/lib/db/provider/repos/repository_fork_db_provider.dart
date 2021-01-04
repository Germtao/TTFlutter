import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/repository.dart';

/// 仓库fork表
class RepositoryForkDBProvider extends BaseDBProvider {
  final String name = 'RepositoryFork';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnData = 'data';

  int id;
  String fullName;
  String data;

  RepositoryForkDBProvider();

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

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryForkDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnData],
      where: '$columnFullName = ?',
      whereArgs: [fullName],
    );
    if (maps.length > 0) {
      RepositoryForkDBProvider provider = RepositoryForkDBProvider.fromMap(maps.first);
      return provider;
    }
    return null;
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

  /// 获取fork仓库列表数据
  Future<List<Repository>> getRepositoryFork(String fullName) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<Repository> list = List();

      // 使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Repository.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
