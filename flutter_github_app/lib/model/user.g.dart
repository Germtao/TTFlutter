// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    login: json['login'] as String,
    id: json['id'] as int,
    nodeId: json['node_id'] as String,
    avatarUrl: json['avatar_url'] as String,
    gravatarId: json['gravatar_id'] as String,
    url: json['url'] as String,
    htmlUrl: json['html_url'] as String,
    followersUrl: json['followers_url'] as String,
    followingUrl: json['following_url'] as String,
    gistsUrl: json['gists_url'] as String,
    starredUrl: json['starred_url'] as String,
    subscriptionsUrl: json['subscriptions_url'] as String,
    organizationsUrl: json['organizations_url'] as String,
    reposUrl: json['repos_url'] as String,
    eventsUrl: json['events_url'] as String,
    receivedEventsUrl: json['received_events_url'] as String,
    type: json['type'] as String,
    siteAdmin: json['site_admin'] as bool,
    name: json['name'] as String,
    company: json['company'] as String,
    blog: json['blog'] as String,
    location: json['location'] as String,
    email: json['email'] as String,
    starred: json['starred'] as String,
    bio: json['bio'] as String,
    publicRepos: json['public_repos'] as int,
    publicGists: json['public_gists'] as int,
    followers: json['followers'] as int,
    following: json['following'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    privateGists: json['private_gists'] as int,
    totalPrivateRepos: json['total_private_repos'] as int,
    ownedPrivateRepos: json['owned_private_repos'] as int,
    diskUsage: json['disk_usage'] as int,
    collaborators: json['collaborators'] as int,
    twoFactorAuthentication: json['two_factor_authentication'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'node_id': instance.nodeId,
      'avatar_url': instance.avatarUrl,
      'gravatar_id': instance.gravatarId,
      'url': instance.url,
      'html_url': instance.htmlUrl,
      'followers_url': instance.followersUrl,
      'following_url': instance.followingUrl,
      'gists_url': instance.gistsUrl,
      'starred_url': instance.starredUrl,
      'subscriptions_url': instance.subscriptionsUrl,
      'organizations_url': instance.organizationsUrl,
      'repos_url': instance.reposUrl,
      'events_url': instance.eventsUrl,
      'received_events_url': instance.receivedEventsUrl,
      'type': instance.type,
      'site_admin': instance.siteAdmin,
      'name': instance.name,
      'company': instance.company,
      'blog': instance.blog,
      'location': instance.location,
      'email': instance.email,
      'starred': instance.starred,
      'bio': instance.bio,
      'public_repos': instance.publicRepos,
      'public_gists': instance.publicGists,
      'followers': instance.followers,
      'following': instance.following,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'private_gists': instance.privateGists,
      'total_private_repos': instance.totalPrivateRepos,
      'owned_private_repos': instance.ownedPrivateRepos,
      'disk_usage': instance.diskUsage,
      'collaborators': instance.collaborators,
      'two_factor_authentication': instance.twoFactorAuthentication,
    };
