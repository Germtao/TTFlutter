import 'package:flutter/material.dart';

class PullLoadWidgetControl extends ChangeNotifier {
  /// 数据，对齐增减，不能替换
  List _dataList = List();

  get dataList => _dataList;

  set dataList(List value) {
    _dataList.clear();
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  addList(List value) {
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  /// 是否需要加载更多
  bool _needLoadMore = true;

  get needLoadMore => _needLoadMore;

  set needLoadMore(value) {
    _needLoadMore = value;
    notifyListeners();
  }

  /// 是否需要头部
  bool _needHeader = true;

  get needHeader => _needHeader;

  set needHeader(value) {
    _needHeader = value;
    notifyListeners();
  }

  /// 是否正在加载中
  bool isLoading = false;
}
