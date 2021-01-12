import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/config/config.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/repository_ql.dart';

/// 本地已读历史表
class ReadHistoryDBProvider extends BaseDBProvider {
  final String name = 'ReadHistory';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnReadDate = 'readDate';
  final String columnData = 'data';

  int id;
  String fullName;
  int readDate;
  String data;

  ReadHistoryDBProvider();

  Map<String, dynamic> toMap(String fullName, DateTime readDate, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnReadDate: readDate.millisecondsSinceEpoch,
      columnData: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ReadHistoryDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    readDate = map[columnReadDate];
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
        $columnReadDate text not null,
        $columnData text not null)
      ''';
  }

  Future _getProvider(Database db, int page) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnReadDate, columnData],
      limit: Config.PAGE_SIZE,
      offset: (page - 1) * Config.PAGE_SIZE,
      orderBy: '$columnReadDate DESC',
    );
    return maps.length > 0 ? maps : null;
  }

  Future _getProviderInsert(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnReadDate, columnData],
      where: '$columnFullName = ?',
      whereArgs: [fullName],
    );
    return maps.length > 0 ? ReadHistoryDBProvider.fromMap(maps.first) : null;
  }

  Future insert(String fullName, DateTime dateTime, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProviderInsert(db, fullName);
    if (provider != null) {
      await db.delete(name, where: '$columnFullName = ?', whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, dateTime, dataMapString));
  }

  /// 获取本地已读历史列表数据
  Future<List<RepositoryQL>> getReadHistory(int page) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, page);
    if (provider != null) {
      List<RepositoryQL> list = List();

      for (var providerMap in provider) {
        ReadHistoryDBProvider provider = ReadHistoryDBProvider.fromMap(providerMap);

        // 使用 compute 的 Isolate 优化 json decode
        var mapData = await compute(CodeUtils.decodeMapResult, provider.data);

        list.add(RepositoryQL.fromMap(mapData));
      }
      return list;
    }
    return null;
  }
}
