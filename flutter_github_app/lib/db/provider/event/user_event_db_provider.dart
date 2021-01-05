import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/event.dart';

/// 用户动态表
class UserEventDBProvider extends BaseDBProvider {
  final String name = 'UserEvent';

  final String columnId = '_id';
  final String columnUserName = 'userName';
  final String columnData = 'data';

  int id;
  String userName;
  String data;

  UserEventDBProvider();

  Map<String, dynamic> toMap(String userName, String data) {
    Map<String, dynamic> map = {columnUserName: userName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserEventDBProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
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
        $columnUserName text not null,
        $columnData text not null)
      ''';
  }

  Future _getProvider(Database db, String userName) async {
    List<Map> maps = await db.query(
      name,
      columns: [columnId, columnUserName, columnData],
      where: '$columnUserName = ?',
      whereArgs: [userName],
    );
    return maps.length > 0 ? UserEventDBProvider.fromMap(maps.first) : null;
  }

  /// 插入到数据库
  Future insert(String userName, String dataMapString) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      await db.delete(name, where: '$columnUserName = ?', whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, dataMapString));
  }

  /// 获取用户动态列表数据
  Future<List<Event>> getUserEvents(String userName) async {
    Database db = await getDatabase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      List<Event> list = List();

      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Event.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
