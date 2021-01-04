import '../../sql_provider.dart';

/// 仓库提交详情表
class RepositoryCommitDetailDBProvider extends BaseDBProvider {
  final String name = 'RepositoryCommitDetail';

  final String columnId = '_id';
  final String columnFullName = 'fullName';
  final String columnSha = 'sha';
  final String columnData = 'data';

  int id;
  String fullName;
  String sha;
  String data;

  RepositoryCommitDetailDBProvider();

  Map<String, dynamic> toMap(String fullName, String sha, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnSha: sha,
      columnData: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryCommitDetailDBProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    sha = map[columnSha];
    data = map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {}
}
