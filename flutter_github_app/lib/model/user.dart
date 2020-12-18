import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String login;
  final int id;
  final String node_id;
  final String avatar_url;
  final String gravatar_id;
  final String url;
  final String html_url;
  final String followers_url;
  final String following_url;
  final String gists_url;
  final String starred_url;
  final String subscriptions_url;
  final String organizations_url;
  final String repos_url;
  final String events_url;
  final String received_events_url;
  final String type;
  final bool site_admin;
  final String name;
  final String company;
  final String blog;
  final String location;
  final String email;
  final String starred;
  final String bio;
  final int public_repos;
  final int public_gists;
  final int followers;
  final int following;
  final DateTime created_at;
  final DateTime updated_at;
  final int private_gists;
  final int total_private_repos;
  final int owned_private_repos;
  final int disk_usage;
  final int collaborators;
  final bool two_factor_authentication;

  User({
    this.login,
    this.id,
    this.node_id,
    this.avatar_url,
    this.gravatar_id,
    this.url,
    this.html_url,
    this.followers_url,
    this.following_url,
    this.gists_url,
    this.starred_url,
    this.subscriptions_url,
    this.organizations_url,
    this.repos_url,
    this.events_url,
    this.received_events_url,
    this.type,
    this.site_admin,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.starred,
    this.bio,
    this.public_repos,
    this.public_gists,
    this.followers,
    this.following,
    this.created_at,
    this.updated_at,
    this.private_gists,
    this.total_private_repos,
    this.owned_private_repos,
    this.disk_usage,
    this.collaborators,
    this.two_factor_authentication,
  });

  // 反序列化
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // 序列化
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 命名构造函数
  // User.empty();
}
