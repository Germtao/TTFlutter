import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../model/issue.dart';
import '../../../common/utils/code_utils.dart';

/// issue 评论表
class IssueCommentDBProvider extends BaseDBProvider {
  final String name = 'IssueComment';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnNumber = 'number';
  final String columnCommentId = 'commentId';
  final String columnData = 'data';

  int id;
  String fullName;
  String number;
  String commentId;
  String data;

  IssueCommentDBProvider();

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
        $columnCommentId text,
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

  IssueCommentDBProvider.fromMap(Map map) {
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
      IssueCommentDBProvider provider = IssueCommentDBProvider.fromMap(maps.first);
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

  /// 获取 issue 列表数据
  Future<List<Issue>> getData(String fullName, String number) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, number);
    if (provider != null) {
      List<Issue> list = new List();

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
