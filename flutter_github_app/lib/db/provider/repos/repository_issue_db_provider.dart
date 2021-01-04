import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/issue.dart';

/// 仓库 issue 表
class RepositoryIssueDBProvider extends BaseDBProvider {
  final String name = 'RepositoryIssue';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnData = 'data';
  final String columnState = 'state';

  int id;
  String fullName;
  String data;
  String state;

  RepositoryIssueDBProvider();

  Map<String, dynamic> toMap(String fullName, String state, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnState: state,
      columnData: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryIssueDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
    state = map[columnState];
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
        $columnState text not null,
        $columnData text not null)
      ''';
  }

  Future _getProvider(Database db, String fullName, String state) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnState, columnData],
      where: '$columnFullName = ? and $columnState = ?',
      whereArgs: [fullName, state],
    );
    if (maps.length > 0) {
      RepositoryIssueDBProvider provider = RepositoryIssueDBProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  /// 插入到数据库
  Future insert(String fullName, String state, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, state);
    if (provider != null) {
      await db.delete(
        name,
        where: '$columnFullName = ? and $columnState = ?',
        whereArgs: [fullName, state],
      );
    }
    return await db.insert(name, toMap(fullName, state, dataMapString));
  }

  /// 获取仓库 issue 列表数据
  Future<List<Issue>> getRepositoryIssue(String fullName, String state) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, state);
    if (provider != null) {
      List<Issue> list = List();

      // 使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Issue.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
