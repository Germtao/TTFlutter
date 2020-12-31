import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../model/repository_ql.dart';
import '../../../common/utils/code_utils.dart';

/// 仓库详情数据库表
class RepositoryDetailDBProvider extends BaseDBProvider {
  final String name = 'RepositoryDetail';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnData = 'data';

  int id;
  String fullName;
  String data;

  RepositoryDetailDBProvider();

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

  RepositoryDetailDBProvider.fromMap(Map map) {
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
      RepositoryDetailDBProvider provider = RepositoryDetailDBProvider.fromMap(maps.first);
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

  /// 获取仓库详情数据
  Future<RepositoryQL> getData(String fullName) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      // 使用 compute 的 Isolate 优化 json decode
      var mapData = await compute(CodeUtils.decodeMapResult, provider.data as String);
      return RepositoryQL.fromMap(mapData);
    }
    return null;
  }
}
