import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/common/net/transformer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common/net/graphql/client.dart';
import '../../common/net/address.dart';
import '../../common/net/api.dart';
import '../../common/net/trending/github.trending.dart';
import '../../db/provider/repos/trend_repository_db_provider.dart';
import '../../db/provider/repos/repository_detail_db_provider.dart';
import '../../db/provider/repos/read_history_db_provider.dart';
import '../../db/provider/repos/repository_event_db_provider.dart';
import '../../db/provider/repos/repository_commits_db_provider.dart';
import '../../db/provider/repos/repository_watch_db_provider.dart';
import '../../db/provider/repos/repository_star_db_provider.dart';
import '../../db/provider/repos/repository_fork_db_provider.dart';
import '../../db/provider/user/user_stared_db_provider.dart';
import '../../db/provider/user/user_repos_db_provider.dart';

import '../../common/dao/dao_result.dart';
import '../../common/config/config.dart';

import '../../model/trending_repo.dart';
import '../../model/repository_ql.dart';
import '../../model/event.dart';
import '../../model/repo_commit.dart';
import '../../model/file_model.dart';
import '../../model/user.dart';
import '../../model/repository.dart';
import '../../model/branch.dart';

class ReposDao {
  /// 获取趋势数据
  /// @param since 数据时长， 本日，本周，本月
  /// @param page  分页
  /// @param languageType 语言类型
  static getTrendDao({since = 'daily', languageType, page = 0, needDb = true}) async {
    TrendRepositoryDBProvider provider = TrendRepositoryDBProvider();
    String languageTypeDB = languageType ?? '*';

    next() async {
      String url = Address.trending(since, languageType);
      var res = await httpManager.netFetch(url, null, {'api-token': Config.API_TOKEN}, null, noTip: true);
      if (res != null && res.result && res.data is List) {
        List<TrendingRepo> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        if (needDb) {
          provider.insert(languageTypeDB + 'V2', since, json.encode(data));
        }
        for (int i = 0; i < data.length; i++) {
          TrendingRepo model = TrendingRepo.fromJson(data[i]);
          list.add(model);
        }
        return new DataResult(list, true);
      } else {
        String url = Address.trending(since, languageType);
        var res = await GithubTrending().fetchTrending(url);
        if (res != null && res.result && res.data.length > 0) {
          List<TrendingRepo> list = List();
          var data = res.data;
          if (data == null || data.length == 0) {
            return new DataResult(null, false);
          }
          if (needDb) {
            provider.insert(languageTypeDB + 'V2', since, json.encode(data));
          }
          for (int i = 0; i < data.length; i++) {
            list.add(data[i]);
          }
          return new DataResult(list, true);
        } else {
          return new DataResult(null, false);
        }
      }
    }

    if (needDb) {
      List<TrendingRepo> list = await provider.getTrendRepository(languageTypeDB + 'V2', since);
      if (list == null || list.length == 0) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取仓库详情数据
  /// @param userName 用户名称
  /// @param reposName 仓库名称
  /// @param branch 分支
  static getRepositoryDetailDao(userName, reposName, branch, {needDb = true}) async {
    String fullName = userName + '/' + reposName + 'v3';
    RepositoryDetailDBProvider provider = RepositoryDetailDBProvider();

    next() async {
      var result = await getRepository(userName, reposName);
      if (result != null && result.data != null) {
        var data = result.data['repository'];
        if (data == null) {
          return new DataResult(null, false);
        }
        var repositoryQL = RepositoryQL.fromMap(data);
        if (needDb) {
          provider.insert(fullName, json.encode(data));
        }
        saveHistoryDao(fullName, DateTime.now(), json.encode(data));
        return new DataResult(repositoryQL, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      RepositoryQL repositoryQL = await provider.getData(fullName);
      if (repositoryQL == null) {
        return await next();
      }
      return new DataResult(repositoryQL, true, next: next);
    }
    return await next();
  }

  /// 仓库活动事件
  static getRepositoryEventDao(userName, reposName, {page = 0, branch = 'master', needDb = false}) async {
    String fullName = userName + '/' + reposName;
    RepositoryEventDBProvider provider = RepositoryEventDBProvider();

    next() async {
      String url = Address.getReposEvent(userName, reposName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Event> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Event.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Event> list = await provider.getRepositoryEvents(fullName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取用户对当前仓库的star、watcher状态
  static getRepositoryStatusDao(userName, reposName) async {
    String urlStar = Address.starRepos(userName, reposName);
    String urlWatch = Address.watchRepos(userName, reposName);
    var resStar = await httpManager.netFetch(urlStar, null, null, null, noTip: true);
    var resWatch = await httpManager.netFetch(urlWatch, null, null, null, noTip: true);
    var data = {'star': resStar.result, 'watch': resWatch.result};
    return DataResult(data, true);
  }

  /// 获取仓库提交列表
  static getRepositoryCommitsDao(userName, reposName, {page = 0, branch = 'master', needDb = false}) async {
    String fullName = userName + '/' + reposName;
    RepositoryCommitsDBProvider provider = RepositoryCommitsDBProvider();

    next() async {
      String url = Address.getReposCommits(userName, reposName) + Address.getPageParams('?', page) + '&sha=$branch';
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<RepoCommit> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(RepoCommit.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, branch, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<RepoCommit> list = await provider.getRepositoryCommits(fullName, branch);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取仓库文件列表
  static getRepositoryFileDirsDao(userName, reposName, {path = '', branch, text = false, isHtml = false}) async {
    String url = Address.reposContentsDir(userName, reposName, path, branch);
    var res = await httpManager.netFetch(
      url,
      null,
      //text ? {"Accept": 'application/vnd.github.VERSION.raw'} : {"Accept": 'application/vnd.github.html'},
      isHtml ? {'Accept': 'application/vnd.github.html'} : {'Accept': 'application/vnd.github.VERSION.raw'},
      Options(contentType: text ? 'text' : 'json'),
    );
    if (res != null && res.result) {
      if (text) {
        return new DataResult(res.data, true);
      }
      List<FileModel> list = List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      List<FileModel> dirs = [];
      List<FileModel> files = [];
      for (int i = 0; i < data.length; i++) {
        FileModel file = FileModel.fromJson(data[i]);
        if (file.type == 'file') {
          files.add(file);
        } else {
          dirs.add(file);
        }
      }
      list.addAll(dirs);
      list.addAll(files);
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// star 仓库
  static Future<DataResult> starRepositoryDao(userName, reposName, star) async {
    String url = Address.starRepos(userName, reposName);
    var res = await httpManager.netFetch(
      url,
      null,
      null,
      Options(method: !star ? 'PUT' : 'DELETE'),
    );
    return Future<DataResult>(() => new DataResult(null, res.result));
  }

  /// watch 仓库
  static watchRepositoryDao(userName, reposName, watch) async {
    String url = Address.watchRepos(userName, reposName);
    print('#### watch: $watch');
    var res = await httpManager.netFetch(
      url,
      null,
      null,
      Options(method: !watch ? 'PUT' : 'DELETE'),
    );
    return new DataResult(null, res.result);
  }

  /// 获取当前仓库所有订阅者
  static getRepositoryWatcherDao(userName, reposName, page, {needDb = false}) async {
    String fullName = userName + '/' + reposName;
    RepositoryWatchDBProvider provider = RepositoryWatchDBProvider();

    next() async {
      String url = Address.getReposWatcher(userName, reposName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.getRespositoryWatch(fullName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取当前仓库所有的[star]用户
  static getRepositoryStarsDao(userName, reposName, page, {needDb = false}) async {
    String fullName = userName + '/' + reposName;
    RepositoryStarDBProvider provider = RepositoryStarDBProvider();

    next() async {
      String url = Address.getReposStar(userName, reposName);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.getRepositoryStar(fullName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取仓库的 [fork] 分支
  static getRepositoryForksDao(userName, reposName, page, {needDb = false}) async {
    String fullName = userName + '/' + reposName;
    RepositoryForkDBProvider provider = RepositoryForkDBProvider();

    next() async {
      String url = Address.getReposForks(userName, reposName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null || res.result) {
        List<Repository> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Repository.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Repository> list = await provider.getRepositoryFork(fullName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取用户所有的 [star] 仓库
  static getStarRepositoryDao(userName, page, sort, {needDb = false}) async {
    UserStaredDBProvider provider = UserStaredDBProvider();

    next() async {
      String url = Address.userStar(userName, sort) + Address.getPageParams('&', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Repository> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Repository.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Repository> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 用户的仓库
  static getUserRepositoryDao(userName, page, sort, {needDb = false}) async {
    UserReposDBProvider provider = UserReposDBProvider();

    next() async {
      String url = Address.userRepos(userName, sort) + Address.getPageParams('&', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Repository> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Repository.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Repository> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 创建仓库的 fork 分支
  static createForkDao(userName, reposName) async {
    String url = Address.createFork(userName, reposName);
    var res = await httpManager.netFetch(url, null, null, Options(method: 'POST'));
    return new DataResult(null, res.result);
  }

  /// 获取当前仓库的所有分支
  static getBranchesDao(userName, reposName) async {
    String url = Address.getBranches(userName, reposName);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<String> list = List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        // TODO: 测试代码
        Serializer<Branch> serializerForType = serializers.serializerForType(Branch);
        var test = serializers.deserializeWith<Branch>(serializerForType, data[i]);

        // TODO: 反序列化
        Map result = serializers.serializeWith(serializerForType, test);
        print("###### $test ${result}");

        list.add(data['name']);
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 保存阅读历史
  static saveHistoryDao(String fullName, DateTime dateTime, String data) {
    ReadHistoryDBProvider provider = ReadHistoryDBProvider();
    provider.insert(fullName, dateTime, data);
  }
}
