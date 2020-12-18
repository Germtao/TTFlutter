import 'package:flutter/material.dart';
import './tabs.dart' as TTTab;

/// 支持顶部和顶部的TabBar控件
/// 配合 [AutomaticKeepAliveClientMixin] 可以 [keep] 住
class TabBarWidget extends StatefulWidget {
  final TabType tabType;

  final bool resizeToAvoidBottomPadding;

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget drawer;

  final Widget floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  final Widget bottomBar;

  final List<Widget> footerButtons;

  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onDoublePress;
  final ValueChanged<int> onSinglePress;

  TabBarWidget({
    Key key,
    this.tabType = TabType.top,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.bottomBar,
    this.onDoublePress,
    this.onSinglePress,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomPadding = true,
    this.footerButtons,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

/// 通过 SingleTickerProviderStateMixin 实现 Tab 的动画切换效果
/// (ps: 如果有需要多个嵌套动画效果，你可能需要TickerProviderStateMixin)
class _TabBarWidgetState extends State<TabBarWidget> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  TabController _tabController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.tabItems.length);
  }

  @override
  void dispose() {
    // 整个页面dispose时，记得把控制器也dispose掉，释放内存
    _tabController.dispose();
    super.dispose();
  }

  _navigationPageChanged(index) {
    if (_currentIndex == index) {
      return;
    }
    _currentIndex = index;
    _tabController.animateTo(index);
    widget.onPageChanged?.call(index);
  }

  _navigationTapClick(index) {
    if (_currentIndex == index) {
      return;
    }
    _currentIndex = index;
    widget.onPageChanged?.call(index);

    // 不想要动画
    _pageController.jumpTo(MediaQuery.of(context).size.width * index);
    widget.onSinglePress?.call(index);
  }

  _navigationDoubleTapClick(index) {
    _navigationTapClick(index);
    widget.onDoublePress?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabType == TabType.top) {
      // 顶部 tab bar
      return _renderTopTabbar();
    }
    return _renderBottomTabBar();
  }

  /// 渲染 bottom bar
  _renderBottomTabBar() {
    return Scaffold(
      drawer: widget.drawer,
      appBar: AppBar(
        title: widget.title,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: PageView(
        controller: _pageController,
        children: widget.tabViews,
        onPageChanged: _navigationPageChanged,
      ),
      bottomNavigationBar: Material(
        // 为了适配主题风格，包一层Material实现风格套用
        color: Theme.of(context).primaryColor, // 底部导航栏主题颜色
        child: SafeArea(
          child: TTTab.TabBar(
            // TabBar导航标签，底部导航放到Scaffold的bottomNavigationBar中
            controller: _tabController,
            tabs: widget.tabItems,
            indicatorColor: widget.indicatorColor,
            onDoubleTap: _navigationDoubleTapClick,
            onTap: _navigationTapClick,
          ),
        ),
      ),
    );
  }

  /// 渲染 top tab bar
  _renderTopTabbar() {
    return Scaffold(
      resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
      floatingActionButton: SafeArea(
        child: widget.floatingActionButton ?? Container(),
      ),
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      persistentFooterButtons: widget.footerButtons,
      appBar: AppBar(
        title: widget.title,
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: widget.tabItems,
          indicatorColor: widget.indicatorColor,
          onTap: _navigationTapClick,
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: widget.tabViews,
        onPageChanged: _navigationPageChanged,
      ),
      bottomNavigationBar: widget.bottomBar,
    );
  }
}

enum TabType { top, bottom }
