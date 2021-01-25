import '../config/config.dart';
import '../config/ignore_config.dart';

/// 地址数据
class Address {
  static const String host = 'https://api.github.com/';
  static const String hostWeb = 'https://github.com/';
  static const String graphicHost = 'https://ghchart.rshah.org/';
  static const String updateUrl = 'https://www.pgyer.com/guqa';

  /// 获取授权 post
  static getAuthorization() {
    return '${host}authorizations';
  }

  /// 搜索 get
  static search(q, sort, order, type, page, [pageSize = Config.PAGE_SIZE]) {
    if (type == 'user') {
      return '${host}search/users?q=$q&page=$page&per_page=$pageSize';
    }
    sort ??= 'best%20match';
    order ??= 'desc';
    page ??= 1;
    pageSize ??= Config.PAGE_SIZE;
    return "${host}search/repositories?q=$q&sort=$sort&order=$order&page=$page&per_page=$pageSize";
  }

  /// 搜索 topic tag
  static searchTopic(topic) {
    return "${host}search/repositories?q=topic:$topic&sort=stars&order=desc";
  }

  /// 用户仓库 get
  static userRepos(username, sort) {
    sort ??= 'pushed';
    return '${host}users/$username/repos?sort=$sort';
  }

  /// 仓库详情 get
  static getReposDetail(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName';
  }

  /// 仓库活动 get
  static getReposEvent(reposOwner, reposName) {
    return '${host}networks/$reposOwner/$reposName/events';
  }

  /// 仓库Forks get
  static getReposForks(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/forks';
  }

  /// 仓库Star get
  static getReposStar(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/stargazers';
  }

  /// 仓库Watcher get
  static getReposWatcher(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/subscribers';
  }

  /// 仓库提交 get
  static getReposCommits(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/commits';
  }

  /// 仓库提交详情 get
  static getReposCommitsDetail(reposOwner, reposName, sha) {
    return '${host}repos/$reposOwner/$reposName/commits/$sha';
  }

  /// 仓库Issue get
  static getReposIssue(reposOwner, reposName, state, sort, direction) {
    state ??= 'all';
    sort ??= 'created';
    direction ??= 'desc';
    return '${host}repos/$reposOwner/$reposName/issues?state=$state&sort=$sort&direction=$direction';
  }

  /// 仓库Release get
  static getReposRelease(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/releases';
  }

  /// 仓库Tag get
  static getReposTag(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/tags';
  }

  /// 仓库Contributors get
  static getReposContributors(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/contributors';
  }

  /// 仓库Issue评论 get
  static getIssueComment(reposOwner, reposName, issueNumber) {
    return '${host}repos/$reposOwner/$reposName/issues/$issueNumber/comments';
  }

  /// 仓库Issue详情 get
  static getIssueDetail(reposOwner, reposName, issueNumber) {
    return '${host}repos/$reposOwner/$reposName/issues/$issueNumber';
  }

  /// 增加Issue评论 post
  static addIssueComment(reposOwner, reposName, issueNumber) {
    return '${host}repos/$reposOwner/$reposName/issues/$issueNumber/comments';
  }

  /// 编辑Issue put
  static editIssue(reposOwner, reposName, issueNumber) {
    return '${host}repos/$reposOwner/$reposName/issues/$issueNumber';
  }

  /// 锁定Issue put
  static lockIssue(reposOwner, reposName, issueNumber) {
    return '${host}repos/$reposOwner/$reposName/issues/$issueNumber/lock';
  }

  /// 创建Issue post
  static createIssue(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/issues';
  }

  /// 搜索Issue
  static searchReposIssue(q) {
    return '${host}search/issues?q=$q';
  }

  /// 编辑评论 patch, delete
  static editComment(reposOwner, reposName, commentId) {
    return '${host}repos/$reposOwner/$reposName/issues/comments/$commentId';
  }

  /// 自己的Star get
  static myStar(sort) {
    sort ??= 'updated';
    return '${host}users/starred?sort=$sort';
  }

  /// 用户的Star get
  static userStar(username, sort) {
    sort ??= 'updated';
    return '${host}users/$username/starred?sort=$sort';
  }

  /// 点赞仓库 put
  static starRepos(reposOwner, reposName) {
    return '${host}user/starred/$reposOwner/$reposName';
  }

  /// 订阅仓库 put
  static watchRepos(reposOwner, reposName) {
    return '${host}user/subscriptions/$reposOwner/$reposName';
  }

  /// 仓库内容 get
  static reposContents(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/contents';
  }

  /// 仓库路径下的内容 get
  static reposContentsDir(reposOwner, reposName, path, [branch = 'master']) {
    branch = branch == null ? '' : '?ref=$branch';
    return '${host}repos/$reposOwner/$reposName/contents/$path' + branch;
  }

  /// README 文件地址 get
  static readmeFile(reposFullName, currentBranch) {
    currentBranch = currentBranch == null ? '' : '?ref=$currentBranch';
    return '${host}repos/$reposFullName/readme' + currentBranch;
  }

  /// 我的用户信息 get
  static getMyUserInfo() {
    return '${host}user';
  }

  /// 用户信息 get
  static getUserInfo(username) {
    return '${host}users/$username';
  }

  /// 是否关注 get
  static doFollow(name) {
    return '${host}user/following/$name';
  }

  /// 用户关注 get
  static getUserFollow(username) {
    return '${host}users/$username/following';
  }

  /// 我的关注者 get
  static getMyFollower() {
    return '${host}user/followers';
  }

  /// 用户的关注者 get
  static getUserFollower(username) {
    return '${host}users/$username/followers';
  }

  /// 创建Fork post
  static createFork(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/forks';
  }

  /// 仓库Branch get
  static getBranches(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/branches';
  }

  /// 仓库Fork get
  static getFork(reposOwner, reposName, sort) {
    sort ??= 'newest';
    return '${host}repos/$reposOwner/$reposName/forks?sort=$sort';
  }

  /// 仓库README get
  static getReadme(reposOwner, reposName) {
    return '${host}repos/$reposOwner/$reposName/readme';
  }

  /// 用户收到的事件信息 get
  static getEventReceived(username) {
    return '${host}users/$username/received_events';
  }

  /// 用户相关的事件信息 get
  static getEvent(username) {
    return '${host}users/$username/events';
  }

  /// 组织成员
  static getMember(orgs) {
    return '${host}orgs/$orgs/members';
  }

  /// 获取用户组织
  static getUserOrgs(username) {
    return '${host}users/$username/orgs';
  }

  /// 通知 get
  static getNotification(all, participating) {
    if ((all == null && participating == null) || (all == false && participating == false)) {
      return '${host}notifications';
    }
    all ??= false;
    participating ??= false;
    return '${host}notifications?all=$all&participating=$participating';
  }

  /// 设置通知已读 patch
  static setNotificationAsRead(threadId) {
    return '${host}notifications/threads/$threadId';
  }

  /// 设置所有通知已读 put
  static setAllNotificationAsRead() {
    return '${host}notifications';
  }

  /// 授权地址 get
  static getOAuthUrl() {
    return "https://github.com/login/oauth/authorize?client_id"
        "=${NetConfig.CLIENT_ID}&state=app&"
        "redirect_uri=ttfluttergithubapp://authed";
  }

  /// 趋势 get
  static trending(since, languageType) {
    if (languageType != null) {
      return 'https://github.com/trending/$languageType?since=$since';
    }
    return 'https://github.com/trending?since=$since';
  }

  /// 趋势Api get
  static trandingApi(since, languageType) {
    if (languageType != null) {
      return 'https://guoshuyu.cn/github/trend/list?languageType=$languageType&since=$since';
    }
    return 'https://guoshuyu.cn/github/trend/list?since=$since';
  }

  /// 处理分页参数
  static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return '${tab}page=$page&per_page=$pageSize';
      } else {
        return '${tab}page=$page';
      }
    } else {
      return '';
    }
  }
}
