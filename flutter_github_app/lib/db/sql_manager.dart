import 'dart:io';

import 'package:sqflite/sqflite.dart';

import 'package:flutter_github_app/common/dao/user_dao.dart';

import 'package:flutter_github_app/model/user.dart';

/// 数据库管理
class SqlManager {
  static const _VERSION = 1;

  static const _NAME = 'tt_flutter_github_app.db';

  static Database _database;

  /// 初始化
  static init() async {
    var databasesPath = await getDatabasesPath();
    var userRes = await UserDao.getUserInfoLocal();
    String _dbName = _NAME;
    if (userRes != null && userRes.result) {
      User user = userRes.data;
      if (user != null && user.login != null) {
        _dbName = '${user.login}_$_NAME';
      }
    }
    String path = databasesPath + _dbName;
    if (Platform.isIOS) {
      path = databasesPath + '/' + _dbName;
    }
    _database = await openDatabase(
      path,
      version: _VERSION,
      onCreate: (Database db, int version) async {
        // 创建数据库时，创建表
        // await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
      },
    );
  }

  /// 表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  /// 获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }
}
