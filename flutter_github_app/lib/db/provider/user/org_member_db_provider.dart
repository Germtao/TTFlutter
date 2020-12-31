import '../sql_provider.dart';

/// 组织成员数据库表
class OrgMemberDBProvider extends BaseDBProvider {
  final String name = 'OrgMember';

  final String columnId = '_id';
  final String columnOrg = 'org';
  final String columnData = 'data';

  int id;
  String org;
  String data;

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {}

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {columnOrg: org, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  OrgMemberDBProvider.fromMap(Map map) {
    id = map[columnId];
    org = map[columnOrg];
    data = map[columnData];
  }
}
