import 'dart:convert';

import 'package:dio/dio.dart';

import '../../common/net/address.dart';
import '../../common/net/api.dart';
import '../../common/dao/dao_result.dart';

import '../../db/provider/issue/issue_comment_db_provider.dart';
import '../../db/provider/issue/issue_detail_db_provider.dart';
import '../../db/provider/repos/repository_issue_db_provider.dart';

import '../../model/issue.dart';

class IssueDao {
  /// 获取仓库 issue
  /// @param page
  /// @param userName
  /// @param reposName
  /// @param state issue状态
  /// @param sort 排序类型 created updated等
  /// @param direction 正序或者倒序
  static getRepositoryIssueDao(userName, reposName, state, {sort, direction, page = 0, needDb = false}) async {
    String fullName = userName + '/' + reposName;
    String dbState = state ?? '*';
    RepositoryIssueDBProvider provider = RepositoryIssueDBProvider();

    next() async {
      String url =
          Address.getReposIssue(userName, reposName, state, sort, direction) + Address.getPageParams('&', page);
      var res = await httpManager.netFetch(
        url,
        null,
        {'Accept': 'application/vnd.github.html,application/vnd.github.VERSION.raw'},
        null,
      );
      if (res != null && res.result) {
        List<Issue> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < data.length; i++) {
          list.add(Issue.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, dbState, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Issue> list = await provider.getRepositoryIssue(fullName, dbState);
      if (list == null || list.length == 0) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 搜索仓库 issue
  /// @param q 搜索关键字
  /// @param userName 用户名
  /// @param reposName 仓库名
  /// @param page
  /// @param state 问题状态，all open closed
  static searchRepositoryIssueDao(q, userName, reposName, state, {page = 1}) async {
    if (state == null || state == 'all') {
      q = q + '+repo%3A$userName%2F$reposName';
    } else {
      q = q + '+repo%3A$userName%2F$reposName+state%3A$state';
    }
    String url = Address.searchReposIssue(q) + Address.getPageParams('&', page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Issue> list = List();
      var data = res.data['items'];
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (var i = 0; i < data.length; i++) {
        list.add(Issue.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 获取仓库 issue 详情
  static getRepositoryIssueDetailDao(userName, reposName, number, {needDb = true}) async {
    String fullName = userName + '/' + reposName;
    IssueDetailDBProvider provider = IssueDetailDBProvider();

    next() async {
      String url = Address.getIssueDetail(userName, reposName, number);
      var res = await httpManager.netFetch(
        url,
        null,
        {'Accept': 'application/vnd.github.VERSION.raw'},
        null,
      );
      if (res != null && res.result) {
        if (needDb) {
          provider.insert(fullName, number, json.encode(res.data));
        }
        return new DataResult(Issue.fromJson(res.data), true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      Issue issue = await provider.getData(fullName, number);
      if (issue == null) {
        return await next();
      }
      return new DataResult(issue, true);
    }
    return await next();
  }

  /// 获取仓库 issue 评价列表
  static getRepositoryIssueCommentsDao(userName, reposName, number, {page = 0, needDb = false}) async {
    String fullName = userName + '/' + reposName;
    IssueCommentDBProvider provider = IssueCommentDBProvider();

    next() async {
      String url = Address.getIssueComment(userName, reposName, number) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(
        url,
        null,
        {'Accept': 'application/vnd.github.VERSION.raw'},
        null,
      );
      if (res != null && res.result) {
        List<Issue> list = List();
        if (res.data == null || res.data.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < res.data.length; i++) {
          list.add(Issue.fromJson(res.data[i]));
        }
        if (needDb) {
          provider.insert(fullName, number, json.encode(res.data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Issue> list = await provider.getData(fullName, number);
      if (list == null || list.length == 0) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 增加 issue 评论
  static addIssueCommentDao(userName, reposName, number, comment) async {
    String url = Address.addIssueComment(userName, reposName, number);
    var res = await httpManager.netFetch(
      url,
      {'body': comment},
      {'Accept': 'application/vnd.github.VERSION.full+json'},
      Options(method: 'POST'),
    );
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 编辑 issue
  static editIssueDao(userName, reposName, number, issue) async {
    String url = Address.editIssue(userName, reposName, number);
    var res = await httpManager.netFetch(
      url,
      issue,
      {'Accept': 'application/vnd.github.VERSION.full+json'},
      Options(method: 'PATCH'),
    );
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 锁定 issue
  static lockIssueDao(userName, reposName, number, locked) async {
    String url = Address.lockIssue(userName, reposName, number);
    var res = await httpManager.netFetch(
      url,
      null,
      {'Accept': 'application/vnd.github.VERSION.full+json'},
      Options(method: locked ? 'DELETE' : 'PUT'),
      noTip: true,
    );
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 创建 issue
  static createIssueDao(userName, reposName, issue) async {
    String url = Address.createIssue(userName, reposName);
    var res = await httpManager.netFetch(
      url,
      issue,
      {'Accept': 'application/vnd.github.VERSION.full+json'},
      Options(method: 'POST'),
    );
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 编辑 issue 回复
  static editIssueCommentDao(userName, reposName, number, commentId, comment) async {
    String url = Address.editComment(userName, reposName, commentId);
    var res = await httpManager.netFetch(
      url,
      comment,
      {'Accept': 'application/vnd.github.VERSION.full+json'},
      Options(method: 'PATCH'),
    );
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 删除 issue 回复
  static deleteIssueCommentDao(userName, reposName, number, commentId) async {
    String url = Address.editComment(userName, reposName, commentId);
    var res = await httpManager.netFetch(
      url,
      null,
      null,
      Options(method: 'DELETE'),
      noTip: true,
    );
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
