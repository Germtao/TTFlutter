import 'package:json_annotation/json_annotation.dart';

part 'trending_repo.g.dart';

@JsonSerializable()
class TrendingRepo {
  String fullName;
  String url;

  String description;
  String language;
  String meta;
  List<String> contributors;
  String contributorsUrl;

  String starCount;
  String forkCount;
  String name;

  String reposName;

  TrendingRepo(
    this.fullName,
    this.url,
    this.description,
    this.language,
    this.meta,
    this.contributors,
    this.contributorsUrl,
    this.starCount,
    this.name,
    this.reposName,
    this.forkCount,
  );

  TrendingRepo.empty();

  factory TrendingRepo.fromJson(Map<String, dynamic> json) => _$TrendingRepoFromJson(json);
  Map<String, dynamic> toJson() => _$TrendingRepoToJson(this);
}
