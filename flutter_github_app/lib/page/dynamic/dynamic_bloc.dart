import '../../common/config/config.dart';
import '../../common/dao/event_dao.dart';
import '../../widget/pull/pull_load_widget_control.dart';

class DynamicBloc {
  final PullLoadWidgetControl pullLoadWidgetControl = PullLoadWidgetControl();

  int _page = 1;

  /// 请求刷新
  requestRefresh(String userName, {doNextFlag = true}) async {
    resetPage();
    var res = await EventDao.getEventReceived(userName, page: _page, needDb: true);
    changeLoadMoreStatus(getLoadMoreStatus(res));
    refreshData(res);
    if (doNextFlag) {
      await doNext(res);
    }
    return res;
  }

  /// 请求加载更多
  requestLoadMore(String userName) async {
    upPage();
    var res = await EventDao.getEventReceived(userName, page: _page);
    changeLoadMoreStatus(getLoadMoreStatus(res));
    loadMoreData(res);
    return res;
  }

  resetPage() {
    _page = 1;
  }

  upPage() {
    _page++;
  }

  doNext(res) async {
    if (res.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        changeLoadMoreStatus(getLoadMoreStatus(resNext));
        refreshData(resNext);
      }
    }
  }

  /// 获取加载更多状态
  getLoadMoreStatus(res) {
    return (res != null && res.data != null && res.data.length == Config.PAGE_SIZE);
  }

  /// 修改加载更多状态
  changeLoadMoreStatus(bool needLoadMore) {
    pullLoadWidgetControl.needLoadMore = needLoadMore;
  }

  /// 是否需要头部
  changeNeedHeaderStatus(bool needHeader) {
    pullLoadWidgetControl.needHeader = needHeader;
  }

  /// 刷新数据
  refreshData(res) {
    if (res != null) {
      pullLoadWidgetControl.dataList = res.data;
    }
  }

  /// 加载更多数据
  loadMoreData(res) {
    if (res != null) {
      pullLoadWidgetControl.addList(res.data);
    }
  }

  /// 清理数据
  clearData() {
    refreshData([]);
  }

  /// 列表数据
  get dataList => pullLoadWidgetControl.dataList;

  int getDataLength() {
    return pullLoadWidgetControl.dataList.length;
  }

  void dispose() {
    pullLoadWidgetControl.dispose();
  }
}
