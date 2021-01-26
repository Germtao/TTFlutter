import 'package:flutter_github_app/common/dao/user_dao.dart';
import 'package:flutter_github_app/redux/middleware/epic_store.dart';
import 'package:redux/redux.dart';
import '../model/user.dart';
import 'state.dart';
import 'package:rxdart/rxdart.dart';

/** 用户相关 redux */

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
// ignore: non_constant_identifier_names
final UserReducer = combineReducers<User>([
  TypedReducer<User, UpdateUserAction>(_updateLoaded),
]);

/// 如果有 UpdateUserAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的userInfo，并返回
User _updateLoaded(User user, action) {
  user = action.userInfo;
  return user;
}

/// 定一个 UpdateUserAction ，用于发起 userInfo 的的改变
/// 类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateUserAction {
  final User userInfo;

  UpdateUserAction(this.userInfo);
}

class FetchUserAction {}

class UserInfoMiddleware implements MiddlewareClass<TTState> {
  @override
  call(Store<TTState> store, action, next) {
    if (action is UpdateUserAction) {
      print('********** UserInfoMiddleware **********');
    }

    // 确保将操作转发到链中的下一个中间件！
    next(action);
  }
}

Stream<dynamic> userInfoEpic(Stream<dynamic> actions, EpicStore<TTState> store) {
  // 使用 async* 功能使操作更轻松
  Stream<dynamic> _loadUserInfo() async* {
    print("*********** userInfoEpic _loadUserInfo ***********");
    var res = await UserDao.getUserInfo(null);
    yield UpdateUserAction(res.data);
  }

  return actions
      .whereType<FetchUserAction>()
      // 直到 10ms 才开始
      .debounce(((_) => TimerStream(true, const Duration(milliseconds: 10))))
      .switchMap((action) => _loadUserInfo());
}
