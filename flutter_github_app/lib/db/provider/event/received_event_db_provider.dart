import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../sql_provider.dart';
import '../../../common/utils/code_utils.dart';
import '../../../model/event.dart';

/// 用户接受事件表
class ReceivedEventDBProvider extends BaseDBProvider {
  final String name = 'ReceivedEvent';

  final String columnId = '_id';
  final String columnData = 'data';

  int id;
  String data;

  ReceivedEventDBProvider();

  Map<String, dynamic> toMap(String data) {
    Map<String, dynamic> map = {columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ReceivedEventDBProvider.fromMap(Map map) {
    id = map[columnId];
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
        $columnData text not null)
      ''';
  }

  /// 插入到数据库
  Future insert(String dataMapString) async {
    Database db = await getDatabase();

    // 清空后再插入，因为只保存第一页
    db.execute('delete from $name');
    return await db.insert(name, toMap(dataMapString));
  }

  /// 获取用户接受事件列表数据
  Future<List<Event>> getReceivedEvents() async {
    Database db = await getDatabase();

    List<Map> maps = await db.query(name, columns: [columnId, columnData]);

    List<Event> list = List();

    if (maps.length > 0) {
      ReceivedEventDBProvider provider = ReceivedEventDBProvider.fromMap(maps.first);

      // 使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Event.fromJson(item));
        }
      }
    }
    return list;
  }
}
