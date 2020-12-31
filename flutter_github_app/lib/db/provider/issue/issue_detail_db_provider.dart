import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_github_app/model/issue.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../repos/repository_detail_db_provider.dart';
import '../../../common/utils/code_utils.dart';

class IssueDetailDBProvider extends BaseDBProvider {
  final String name = 'IssueDetail';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnNumber = 'number';
  final String columnData = 'data';

  int id;
  String fullName;
  String number;
  String data;

  IssueDetailDBProvider();

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnNumber text not null,
        $columnData text not null)
      ''';
  }

  Map<String, dynamic> toMap(String fullName, String number, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnNumber: number,
      columnData: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  IssueDetailDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    number = map[columnNumber];
    data = map[columnData];
  }

  Future _getProvider(Database db, String fullName, String number) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnNumber, columnData],
      where: '$columnFullName = ? and $columnNumber = ?',
      whereArgs: [fullName, number],
    );
    if (maps.length > 0) {
      RepositoryDetailDBProvider provider = RepositoryDetailDBProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  /// 插入到数据库
  Future insert(String fullName, String number, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, number);
    if (provider != null) {
      await db.delete(
        name,
        where: '$columnFullName = ? and $columnNumber = ?',
        whereArgs: [fullName, number],
      );
    }
    return await db.insert(name, toMap(fullName, number, dataMapString));
  }

  /// 获取 issue 详情数据
  Future<Issue> getData(String fullName, String number) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, number);
    if (provider != null) {
      // 使用 compute 的 Isolate 优化 json decode
      var mapData = await compute(CodeUtils.decodeMapResult, provider.data as String);
      return Issue.fromJson(mapData);
    }
    return null;
  }
}
