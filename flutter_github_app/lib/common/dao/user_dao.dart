import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/net/graphql/client.dart';
import 'package:flutter_github_app/redux/locale_redux.dart';
import 'package:flutter_github_app/redux/user_redux.dart';
import 'package:redux/redux.dart';

import 'dao_result.dart';

import '../../common/net/address.dart';
import '../../common/net/result_data.dart';
import '../../common/net/api.dart';

import '../../db/provider/user/user_info_db_provider.dart';
import '../../db/provider/user/user_follower_db_provider.dart';
import '../../db/provider/user/user_followed_db_provider.dart';
import '../../db/provider/user/user_orgs_db_provider.dart';

import '../local/local_storage.dart';
import '../config/config.dart';
import '../config/ignore_config.dart';

import '../utils/common_utils.dart';

import '../../model/user.dart';
import '../../model/notification.dart' as Model;
import '../../model/user_org.dart';
import '../../model/search_user_ql.dart';

class UserDao {
  /// 授权
  static oAuth(code, store) async {
    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(
      "https://github.com/login/oauth/access_token?"
      "client_id=${NetConfig.CLIENT_ID}"
      "&client_secret=${NetConfig.CLIENT_SECRET}"
      "&code=$code",
      null,
      null,
      null,
    );
    var resultData;
    if (res != null && res.result) {
      print('#### ${res.data}');
      var result = Uri.parse('tt://oauth?${res.data}');
      var token = result.queryParameters['access_token'];
      var _token = 'token $token';
      await LocalStorage.save(Config.TOKEN_KEY, _token);

      resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      if (resultData.result == true) {
        store.dispatch(UpdateUserAction(resultData.data));
      }
    }
    return DataResult(resultData, res.result);
  }

  /// 登录
  static login(userName, password, store) async {
    String type = userName + ':' + password;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (Config.DEBUG) {
      print('base64Str login: $base64Str');
    }

    await LocalStorage.save(Config.USER_NAME_KEY, userName);
    await LocalStorage.save(Config.USER_BASIC_CODE, base64Str);

    Map requestParams = {
      'scopes': ['user', 'repo', 'gist', 'notifications'],
      'note': 'admin_script',
      'client_id': NetConfig.CLIENT_ID,
      'client_secret': NetConfig.CLIENT_SECRET,
    };
    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(
      Address.getAuthorization(),
      json.encode(requestParams),
      null,
      Options(method: 'post'),
    );
    var resultData;
    if (res != null && res.result) {
      await LocalStorage.save(Config.PASS_WORD_KEY, password);
      resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print('user result ${resultData.result.toString()}');
        print(resultData.data);
        print(res.data.toString());
      }
      store.dispatch(UpdateUserAction(resultData.data));
    }
    return DataResult(resultData, res.result);
  }

  /// 初始化用户信息
  static initUserInfo(Store store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }

    // 读取主题
    String themeIndex = await LocalStorage.get(Config.THEME_COLOR);
    if (themeIndex != null && themeIndex.length != 0) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }

    // 切换语言
    String localeIndex = await LocalStorage.get(Config.LOCALE);
    if (localeIndex != null && localeIndex.length != 0) {
      CommonUtils.changeLocale(store, int.parse(localeIndex));
    } else {
      CommonUtils.currentLocale = store.state.platformLocale;
      store.dispatch(RefreshLocaleAction(store.state.platformLocale));
    }

    return DataResult(res.data, res.result && token != null);
  }

  /// 获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return DataResult(user, true);
    } else {
      return DataResult(null, false);
    }
  }

  /// 获取用户详细信息
  static getUserInfo(userName, {needDb = false}) async {
    UserInfoDBProvider provider = UserInfoDBProvider();

    next() async {
      ResultData res;
      if (userName == null) {
        res = await httpManager.netFetch(Address.getMyUserInfo(), null, null, null);
      } else {
        res = await httpManager.netFetch(Address.getUserInfo(userName), null, null, null);
      }

      if (res != null && res.result) {
        String starred = '---';
        if (res.data['type'] != 'Organization') {
          var countRes = await getUserStarredCountNet(res.data['login']);
          if (countRes.result) {
            starred = countRes.data;
          }
        }

        User user = User.fromJson(res.data);
        user.starred = starred;
        if (userName == null) {
          LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));
        } else {
          if (needDb) {
            provider.insert(userName, json.encode(user.toJson()));
          }
        }
        return new DataResult(user, true);
      } else {
        return DataResult(res.data, false);
      }
    }

    if (needDb) {
      User user = await provider.getUserInfo(userName);
      if (user == null) {
        return await next();
      }
      DataResult dataResult = DataResult(user, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static clearAll(Store store) async {
    httpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(UpdateUserAction(User.empty()));
  }

  /// 在[header]中提起 [starred count]
  /// [DataResult]
  static getUserStarredCountNet(userName) async {
    String url = Address.userStar(userName, null) + '&per_page=1';
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> links = res.headers['link'];
        if (links != null) {
          int indexStart = links[0].lastIndexOf('page=') + 5;
          int indexEnd = links[0].lastIndexOf('>');
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = links[0].substring(indexStart, indexEnd);
            return DataResult(count, true);
          }
        }
      } catch (e) {
        print('get user starred count net error: $e');
      }
    }
    return DataResult(null, false);
  }

  /// 获取用户粉丝列表
  static getFollowerListDao(userName, page, {needDb = false}) async {
    UserFollowerDBProvider provider = UserFollowerDBProvider();

    next() async {
      String url = Address.getUserFollower(userName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(User.fromJson(data[i]));
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
      List<User> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 获取用户关注列表
  static getFollowedListDao(userName, page, {needDb = false}) async {
    UserFollowedDBProvider provider = UserFollowedDBProvider();

    next() async {
      String url = Address.getUserFollow(userName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(User.fromJson(data[i]));
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
      List<User> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }

    return await next();
  }

  /// 获取用户相关通知
  static getNotifyDao(bool all, bool participating, page) async {
    String tag = (!all && !participating) ? '?' : '&';
    String url = Address.getNotification(all, participating) + Address.getPageParams(tag, page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Model.Notification> list = List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Model.Notification.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 设置单个通知已读
  static setNotificationAsReadDao(id) async {
    String url = Address.setNotificationAsRead(id);
    var res = await httpManager.netFetch(
      url,
      null,
      null,
      Options(method: 'PATCH'),
      noTip: true,
    );
    return res;
  }

  /// 设置所有通知已读
  static setAllNotificationAsReadDao() async {
    String url = Address.setAllNotificationAsRead();
    var res = await httpManager.netFetch(url, null, null, Options(method: 'PUT'));
    return new DataResult(res.data, res.result);
  }

  /// 检查用户关注状态
  static checkFollowDao(name) async {
    String url = Address.doFollow(name);
    var res = await httpManager.netFetch(url, null, null, null, noTip: true);
    return new DataResult(res.data, res.result);
  }

  /// 关注用户
  static doFollowDao(name, bool followed) async {
    String url = Address.doFollow(name);
    var res = await httpManager.netFetch(
      url,
      null,
      null,
      Options(method: followed ? 'DELETE' : 'PUT'),
      noTip: true,
    );
    return new DataResult(res.data, res.result);
  }

  /// 组织成员
  static getMemberDao(userName, page) async {
    String url = Address.getMember(userName) + Address.getPageParams('?', page);
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
      return new DataResult(res.data, res.result);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 更新用户信息
  static updateUserDao(params, Store store) async {
    String url = Address.getMyUserInfo();
    var res = await httpManager.netFetch(url, params, null, Options(method: 'PATCH'));
    if (res != null && res.result) {
      var localResult = await getUserInfoLocal();
      User newUser = User.fromJson(res.data);
      newUser.starred = localResult.data.starred;
      await LocalStorage.save(Config.USER_INFO, newUser.toJson());
      store.dispatch(UpdateUserAction(newUser));
      return new DataResult(newUser, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 获取用户组织
  static getUserOrgsDao(userName, page, {needDb = false}) async {
    UserOrgsDBProvider provider = UserOrgsDBProvider();

    next() async {
      String url = Address.getUserOrgs(userName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<UserOrg> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(UserOrg.fromJson(data[i]));
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
      List<UserOrg> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 搜索趋势用户
  static searchTrendUserDao(String location, {String cursor, ValueChanged valueChanged}) async {
    var res = await getTrendUser(location, cursor: cursor);
    if (res != null && res.data != null) {
      var endCursor = res.data["search"]["pageInfo"]["endCursor"];
      var dataList = res.data["search"]["user"];
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      var dataResult = List();
      valueChanged?.call(endCursor);
      dataList.forEach((item) {
        var userModel = SearchUserQL.fromMap(item['user']);
        dataResult.add(userModel);
      });
      return new DataResult(dataResult, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
