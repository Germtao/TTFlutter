import 'package:json_annotation/json_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileModel {
  String name;
  String path;
  String sha;
  int size;
  String url;
  @JsonKey(name: "html_url")
  String htmlUrl;
  @JsonKey(name: "git_url")
  String gitUrl;
  @JsonKey(name: "download_url")
  String downloadUrl;
  @JsonKey(name: "type")
  String type;

  FileModel(
    this.name,
    this.path,
    this.sha,
    this.size,
    this.url,
    this.htmlUrl,
    this.gitUrl,
    this.downloadUrl,
    this.type,
  );
}
