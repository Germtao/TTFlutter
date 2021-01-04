import '../../sql_provider.dart';

/// 仓库 pulse 表
class RepositoryPulseDBProvider extends BaseDBProvider {
  final String name = 'RepositoryPulse';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnData = 'data';

  int id;
  String fullName;
  String data;

  RepositoryPulseDBProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryPulseDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {}
}
