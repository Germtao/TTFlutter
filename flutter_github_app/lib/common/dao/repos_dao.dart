import 'dart:convert';
import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../common/net/graphql/client.dart';
import '../../common/net/address.dart';
import '../../common/net/api.dart';
import '../../common/net/trending/github.trending.dart';
import '../../common/net/transformer.dart';
import '../../common/dao/dao_result.dart';
import '../../common/config/config.dart';
import '../../common/utils/common_utils.dart';
import '../../common/localization/default_localizations.dart';

import '../../db/provider/repos/trend_repository_db_provider.dart';
import '../../db/provider/repos/repository_detail_db_provider.dart';
import '../../db/provider/repos/read_history_db_provider.dart';
import '../../db/provider/repos/repository_event_db_provider.dart';
import '../../db/provider/repos/repository_commits_db_provider.dart';
import '../../db/provider/repos/repository_watch_db_provider.dart';
import '../../db/provider/repos/repository_star_db_provider.dart';
import '../../db/provider/repos/repository_fork_db_provider.dart';
import '../../db/provider/repos/repository_detail_readme_db_provider.dart';

import '../../db/provider/user/user_stared_db_provider.dart';
import '../../db/provider/user/user_repos_db_provider.dart';

import '../../model/trending_repo.dart';
import '../../model/repository_ql.dart';
import '../../model/event.dart';
import '../../model/repo_commit.dart';
import '../../model/file_model.dart';
import '../../model/user.dart';
import '../../model/repository.dart';
import '../../model/branch.dart';
import '../../model/push_commit.dart';
import '../../model/release.dart';

class ReposDao {
  /// 获取趋势数据
  /// @param since 数据时长， 本日，本周，本月
  /// @param page  分页
  /// @param languageType 语言类型
  static getTrendDao({since = 'daily', languageType, page = 0, needDb = true}) async {
    TrendRepositoryDBProvider provider = TrendRepositoryDBProvider();
    String languageTypeDB = languageType ?? '*';

    next() async {
      String url = Address.trendingApi(since, languageType);
      var res = await httpManager.netFetch(
        url,
        null,
        {'api-token': Config.API_TOKEN},
        null,
        noTip: true,
      );
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

  /// 获取用户前100仓库
  static getUserRepository100StatusDao(userName) async {
    String url = Address.userRepos(userName, 'pushed') + '&page=1&per_page=100';
    var res = await httpManager.netFetch(url, null, null, null);
    List<Repository> honorList = List();
    if (res != null && res.result && res.data.length > 0) {
      int stared = 0;
      for (int i = 0; i < res.data.length; i++) {
        Repository repository = Repository.fromJson(res.data[i]);
        stared += repository.watchersCount;
        honorList.add(repository);
      }
      // 排序
      honorList.sort((r1, r2) => r2.watchersCount - r1.watchersCount);
      return new DataResult({'stared': stared, 'list': honorList}, true);
    }
    return new DataResult(null, false);
  }

  /// 仓库详情 readme 数据
  static getRepositoryDetailReadmeDao(userName, reposName, branch, {needDb = true}) async {
    String fullName = userName + '/' + reposName;
    RepositoryDetailReadmeDBProvider provider = RepositoryDetailReadmeDBProvider();

    next() async {
      String url = Address.readmeFile(fullName, branch);
      var res = await httpManager.netFetch(
        url,
        null,
        {"Accept": 'application/vnd.github.VERSION.raw'},
        Options(contentType: "text/plain; charset=utf-8"),
      );
      if (res != null && res.result) {
        if (needDb) {
          provider.insert(fullName, branch, res.data);
        }
        return new DataResult(res.data, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      String readme = await provider.getRepositoryReadme(fullName, branch);
      if (readme == null) {
        return await next();
      }
      return new DataResult(readme, true, next: next);
    }
    return await next();
  }

  /// 搜索仓库
  /// @param q 搜索关键字
  /// @param sort 分类排序，beat match、most star等
  /// @param order 倒序或者正序
  /// @param type 搜索类型，人或者仓库 null \ 'user',
  /// @param page
  /// @param pageSize
  static searchRepositoryDao(q, language, sort, order, type, page, pageSize) async {
    if (language != null) {
      q = q + '%2Blanguage%3A$language';
    }
    String url = Address.search(q, sort, order, type, page, pageSize);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.data['items'] != null) {
      var dataList = res.data['items'];
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      if (type == null) {
        List<Repository> list = List();
        for (int i = 0; i < dataList.length; i++) {
          list.add(Repository.fromJson(dataList[i]));
        }
        return new DataResult(list, true);
      } else {
        List<User> list = List();
        for (int i = 0; i < dataList.length; i++) {
          list.add(User.fromJson(dataList[i]));
        }
        return new DataResult(list, true);
      }
    } else {
      return new DataResult(null, false);
    }
  }

  /// 获取仓库单个提交详情
  static getRepositoryCommitsDetailDao(userName, reposName, sha) async {
    String url = Address.getReposCommitsDetail(userName, reposName, sha);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      PushCommit pushCommit = PushCommit.fromJson(res.data);
      return new DataResult(pushCommit, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 获取仓库的 release 列表
  static getRepositoryReleaseDao(userName, reposName, page, {release = true}) async {
    String url = release
        ? Address.getReposRelease(userName, reposName) + Address.getPageParams('?', page)
        : Address.getReposTag(userName, reposName) + Address.getPageParams('?', page);

    var res = await httpManager.netFetch(
      url,
      null,
      {'Accept': 'application/vnd.github.html,application/vnd.github.VERSION.raw'},
      null,
    );
    if (res != null && res.result) {
      List<Release> list = List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < dataList.length; i++) {
        list.add(Release.fromJson(dataList[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 版本更新
  static getNewsVersion(context, showTip) async {
    // iOS 不检查更新
    if (Platform.isIOS) {
      return;
    }

    var res = await getRepositoryReleaseDao('Germtao', 'flutter_github_app', 1);
    if (res != null && res.result && res.data.length > 0) {
      Release release = res.data[0];
      String versionName = release.name;
      if (versionName != null) {
        if (Config.DEBUG) {
          print('versionName = $versionName');
        }

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        var appVersion = packageInfo.version;

        if (Config.DEBUG) {
          print('appVersion = $appVersion');
        }

        Version versionNameNum = Version.parse(versionName);
        Version currentNum = Version.parse(appVersion);
        int result = versionNameNum.compareTo(currentNum);
        if (Config.DEBUG) {
          print('versionNameNum = ${versionNameNum.toString()} \n currentNum = ${currentNum.toString()}');
          print('### newsHad = ${result.toString()}');
        }

        if (result > 0) {
          CommonUtils.showUpdateDialog(context, '${release.name}: ${release.body}');
        } else {
          if (showTip) {
            Fluttertoast.showToast(msg: TTLocalizations.i18n(context).appNotNewVersion);
          }
        }
      }
    }
  }

  /// 获取 issue 总数
  static getRepositoryIssueStatusDao(userName, reposName) async {
    String url = Address.getReposIssue(userName, reposName, null, null, null) + '&per_page=1';
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> links = res.headers['link'];
        if (links != null) {
          int indexStart = links[0].lastIndexOf('page=') + 5;
          int indexEnd = links[0].lastIndexOf('>');
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = links[0].substring(indexStart, indexEnd);
            return new DataResult(count, true);
          }
        }
      } catch (e) {
        print('获取 issue 总数 error: $e');
      }
    }
    return new DataResult(null, false);
  }

  /// 搜索话题
  static searchTopicRepositoryDao(searchTopic, {page = 0}) async {
    String url = Address.searchTopic(searchTopic) + Address.getPageParams('&', page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Repository> list = List();
      var dataList = (res.data != null && res.data['items'] != null) ? res.data['items'] : res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < dataList.length; i++) {
        list.add(Repository.fromJson(dataList[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 获取阅读历史
  static getHistoryDao(page) async {
    ReadHistoryDBProvider provider = ReadHistoryDBProvider();
    List<RepositoryQL> list = await provider.getReadHistory(page);
    if (list == null || list.length == 0) {
      return DataResult(null, false);
    }
    return DataResult(list, true);
  }

  /// 保存阅读历史
  static saveHistoryDao(String fullName, DateTime dateTime, String data) {
    ReadHistoryDBProvider provider = ReadHistoryDBProvider();
    provider.insert(fullName, dateTime, data);
  }
}
