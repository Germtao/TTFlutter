import 'dart:async';

import 'package:flutter_github_app/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 仓库 readme 文件表
class RepositoryDetailReadmeDBProvider extends BaseDBProvider {
  final String name = 'RepositoryDetailReadme';

  final String columnId = '_id';
  final String columnFullName = 'fulleName';
  final String columnBranch = 'branch';
  final String columnData = 'data';

  int id;
  String fullName;
  String branch;
  String data;

  RepositoryDetailReadmeDBProvider();

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnBranch text not null,
        $columnData text not null)
      ''';
  }

  Map<String, dynamic> toMap(String fullName, String branch, String dataMapString) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnBranch: branch,
      columnData: dataMapString,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryDetailReadmeDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    branch = map[columnBranch];
    data = map[columnData];
  }

  Future _getProvider(Database db, String fullName, String branch) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnData],
      where: '$columnFullName = ? and $columnBranch = ?',
      whereArgs: [fullName, branch],
    );
    if (maps.length > 0) {
      RepositoryDetailReadmeDBProvider provider = RepositoryDetailReadmeDBProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  /// 插入到数据库
  Future insert(String fullName, String branch, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      await db.delete(
        name,
        where: '$columnFullName = ? and $columnBranch = ?',
        whereArgs: [fullName, branch],
      );
    }
    return await db.insert(name, toMap(fullName, branch, dataMapString));
  }

  /// 获取仓库 readme 详情数据
  Future<String> getRepositoryReadme(String fullName, String branch) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      return provider.data;
    }
    return null;
  }
}
