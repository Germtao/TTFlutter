import 'package:redux/redux.dart';
import 'dart:async';

/// 精简的Redux [Store]。删除不受支持的 [Store] 方法
/// 由于使用 Dart 实施流的方式，因此无法
/// 从 [Epic] 中执行 `store.dispatch` 或直接观察 store
class EpicStore<State> {
  final Store<State> _store;

  EpicStore(this._store);

  /// 返回 redux 存储的当前状态
  State get state => _store.state;

  Stream<State> get onChange => _store.onChange;

  /// through to the reducer.
  dynamic dispatch(dynamic action) {
    return _store.dispatch(action);
  }
}
