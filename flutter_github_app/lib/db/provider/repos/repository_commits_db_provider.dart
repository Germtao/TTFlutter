import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_github_app/db/provider/repos/repository_branch_db_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/repo_commit.dart';

class RepositoryCommitsDBProvider extends BaseDBProvider {
  final String name = 'RepositoryCommits';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnBranch = 'branch';
  final String columnData = 'data';

  int id;
  String fullName;
  String branch;
  String data;

  RepositoryCommitsDBProvider();

  Map<String, dynamic> toMap(String fullName, String branch, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnBranch: branch,
      columnData: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryCommitsDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    branch = map[columnBranch];
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
        $columnBranch text not null,
        $columnData text not null)
      ''';
  }

  Future _getProvider(Database db, String fullName, String branch) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnBranch, columnData],
      where: '$columnFullName = ? and $columnBranch = ?',
      whereArgs: [fullName, branch],
    );
    return maps.length > 0 ? RepositoryBranchDBProvider.fromMap(maps.first) : null;
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

  /// 获取仓库提交列表数据
  Future<List<RepoCommit>> getRepositoryCommits(String fullName, String branch) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      List<RepoCommit> list = List();

      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(RepoCommit.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
