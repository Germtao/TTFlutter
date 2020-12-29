import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'commit_git_info.dart';

part 'repo_commit.g.dart';

@JsonSerializable()
class RepoCommit {
  String sha;
  String url;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'comments_url')
  String commentsUrl;

  CommitGitInfo commit;
  User author;
  User committer;
  List<RepoCommit> parents;

  RepoCommit(
    this.sha,
    this.url,
    this.htmlUrl,
    this.commentsUrl,
    this.commit,
    this.author,
    this.committer,
    this.parents,
  );

  factory RepoCommit.fromJson(Map<String, dynamic> json) => _$RepoCommitFromJson(json);

  Map<String, dynamic> toJson() => _$RepoCommitToJson(this);
}
