import 'package:json_annotation/json_annotation.dart';
import 'commit_file.dart';
import 'repo_commit.dart';

part 'commit_comparison.g.dart';

@JsonSerializable()
class CommitComparison {
  String url;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'base_commit')
  RepoCommit baseCommit;
  @JsonKey(name: 'merge_base_commit')
  RepoCommit mergeBaseCommit;
  String status;
  @JsonKey(name: 'total_commits')
  int totalCommits;
  List<RepoCommit> commits;
  List<CommitFile> files;

  CommitComparison(
    this.url,
    this.htmlUrl,
    this.baseCommit,
    this.mergeBaseCommit,
    this.status,
    this.totalCommits,
    this.commits,
    this.files,
  );

  factory CommitComparison.fromJson(Map<String, dynamic> json) => _$CommitComparisonFromJson(json);

  Map<String, dynamic> toJson() => _$CommitComparisonToJson(this);
}
