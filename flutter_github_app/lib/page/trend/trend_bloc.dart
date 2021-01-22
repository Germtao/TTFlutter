import 'package:flutter_github_app/common/dao/repos_dao.dart';
import 'package:flutter_github_app/model/trending_repo.dart';
import 'package:flutter_github_app/page/trend/trend_page.dart';
import 'package:rxdart/rxdart.dart';

class TrendBloc {
  bool _requested = false;
  bool _isLoading = false;

  /// 是否正在加载
  bool get isLoading => _isLoading;

  /// 是否已经请求过
  bool get requested => _requested;

  /// rxdart 实现的 stream
  var _subject = PublishSubject<List<TrendingRepo>>();

  Stream<List<TrendingRepo>> get stream => _subject.stream;

  /// 请求刷新
  Future<void> requestRefresh(TrendTypeModel selectTime, TrendTypeModel selectType) async {
    _isLoading = true;
    var res = await ReposDao.getTrendDao(since: selectTime.value, languageType: selectType.value);
    if (res != null && res.result) {
      _subject.add(res.data);
    }
    await doNext(res);
    _isLoading = false;
    _requested = true;
    return;
  }

  /// 请求next，是否有网络
  doNext(res) async {
    if (res.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        _subject.add(resNext.data);
      }
    }
  }
}
