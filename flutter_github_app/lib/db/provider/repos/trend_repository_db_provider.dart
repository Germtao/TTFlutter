import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/trending_repo.dart';

/// 仓库趋势表
class TrendRepositoryDBProvider extends BaseDBProvider {
  final String name = 'TrendRepository';

  final String columnId = '_id';
  final String columnLanguageType = 'languageType';
  final String columnSince = 'since';
  final String columnData = 'data';

  int id;
  String languageType;
  String since;
  String data;

  TrendRepositoryDBProvider();

  Map<String, dynamic> toMap(String languageType, String since, String data) {
    Map<String, dynamic> map = {
      columnLanguageType: languageType,
      columnSince: since,
      columnData: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  TrendRepositoryDBProvider.fromMap(Map map) {
    id = map[columnId];
    since = map[columnSince];
    languageType = map[columnLanguageType];
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
        $columnLanguageType text not null,
        $columnSince text not null,
        $columnData text not null)
      ''';
  }

  /// 插入到数据库
  Future insert(String languageType, String since, String dataMapString) async {
    Database db = await getDatabase();

    // 清空后再插入，因为只保存第一页面
    db.execute('delete from $name');
    return await db.insert(name, toMap(languageType, since, dataMapString));
  }

  /// 获取仓库趋势列表数据
  Future<List<TrendingRepo>> getTrendRepository(String languageType, String since) async {
    Database db = await getDatabase();

    List<Map> maps = await db.query(
      name,
      columns: [columnId, columnLanguageType, columnSince, columnData],
      where: '$columnLanguageType = ? and $columnSince = ?',
      whereArgs: [languageType, since],
    );

    List<TrendingRepo> list = List();

    if (maps.length > 0) {
      TrendRepositoryDBProvider provider = TrendRepositoryDBProvider.fromMap(maps.first);

      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(TrendingRepo.fromJson(item));
        }
      }
    }
    return list;
  }
}
