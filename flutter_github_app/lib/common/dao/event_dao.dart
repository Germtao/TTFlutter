import 'dart:convert';

import '../../common/net/address.dart';
import '../../common/net/api.dart';
import '../../common/dao/dao_result.dart';

import '../../db/provider/event/received_event_db_provider.dart';
import '../../db/provider/event/user_event_db_provider.dart';

import '../../model/event.dart';

class EventDao {
  /// 获取已接收的事件
  static getEventReceived(userName, {page = 1, needDb = false}) async {
    if (userName == null) {
      return null;
    }

    ReceivedEventDBProvider provider = ReceivedEventDBProvider();

    next() async {
      String url = Address.getEventReceived(userName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Event> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return null;
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Event.fromJson(data[i]));
        }
        if (needDb) {
          await provider.insert(json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Event> list = await provider.getReceivedEvents();
      if (list == null || list.length == 0) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }

  /// 用户行为事件
  static getEventDao(userName, {page = 0, needDb = false}) async {
    UserEventDBProvider provider = UserEventDBProvider();

    next() async {
      String url = Address.getEvent(userName) + Address.getPageParams('?', page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Event> list = List();
        var dataList = res.data;
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          list.add(Event.fromJson(dataList[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(dataList));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Event> list = await provider.getUserEvents(userName);
      if (list == null || list.length == 0) {
        return await next();
      }
      return new DataResult(list, true, next: next);
    }
    return await next();
  }
}
