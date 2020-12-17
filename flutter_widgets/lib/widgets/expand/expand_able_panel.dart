import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/expand/expand_able_notifier.dart';
import 'expand_able.dart';
import 'expand_able_controller.dart';

/// 确定 展开/折叠 图标在 [ExpandablePanel] 中的位置
enum ExpandablePanelIconPlacement { left, right }

/// 一个可配置的小部件，用于通过可选的扩展按钮显示用户可扩展的内容
class ExpandablePanel extends StatelessWidget {
  final Widget header;
  final Widget collapsed;
  final Widget expanded;
  final Widget expandableIcon;

  /// 如果为true，则首先展开面板
  final bool initialExpanded;

  /// 如果为true，则用户可以单击标题以展开
  final bool tapHeaderToExpand;

  /// 如果为true，则在右侧显示一个展开图标
  final bool hasIcon;

  final ExpandableBuilder builder;

  final double height;

  /// 展开/折叠图标放置
  final ExpandablePanelIconPlacement iconPlacement;

  final ExpandableController controller;

  static Widget defaultExpandableBuilder(BuildContext context, Widget collapsed, Widget expanded) {
    return Expandable(
      collapsed: collapsed,
      expanded: expanded,
    );
  }

  ExpandablePanel({
    this.header,
    this.collapsed,
    this.expanded,
    this.expandableIcon,
    this.initialExpanded = false,
    this.tapHeaderToExpand = true,
    this.hasIcon = true,
    this.height = 56.5,
    this.controller,
    this.iconPlacement = ExpandablePanelIconPlacement.right,
    this.builder = defaultExpandableBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildHeaderRow(Widget child) {
      if (!hasIcon) {
        return child;
      } else {
        final rowChildren = <Widget>[
          Expanded(child: child),
          Center(
            child: Container(
              height: height,
              child: expandableIcon ?? ExpandableIcon(),
            ),
          ),
        ];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: iconPlacement == ExpandablePanelIconPlacement.right ? rowChildren : rowChildren.reversed.toList(),
        );
      }
    }

    Widget buildHeader(Widget child) {
      return tapHeaderToExpand
          ? ExpandableButton(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 45.0),
                child: child,
              ),
            )
          : child;
    }

    Widget buildWithHeader() {
      return Column(
        children: [
          buildHeaderRow(buildHeader(header)),
          builder(context, collapsed, expanded),
        ],
      );
    }

    Widget buildWithoutHeader() {
      return buildHeaderRow(builder(context, buildHeader(collapsed), expanded));
    }

    return ExpandableNotifier(
      controller: controller ?? ExpandableController(initialExpanded: initialExpanded),
      child: this.header != null ? buildWithHeader() : buildWithoutHeader(),
    );
  }
}

/// 当用户单击 [ExpandableController] 的状态时，使用向下/向上箭头图标
/// 通过 [ScopedModelDescendant] 访问模型
class ExpandableIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = ExpandableController.of(context);
    return ExpandIcon(
      isExpanded: controller.expanded,
      onPressed: (expanded) {
        controller.toggle();
      },
    );
  }
}

/// 用户单击时切换 [ExpandableController] 的状态
class ExpandableButton extends StatelessWidget {
  final Widget child;

  ExpandableButton({this.child});

  @override
  Widget build(BuildContext context) {
    final controller = ExpandableController.of(context);
    return InkWell(
      onTap: () => controller.toggle(),
      child: child,
    );
  }
}
