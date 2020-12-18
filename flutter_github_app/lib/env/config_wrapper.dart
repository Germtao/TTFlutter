import 'package:flutter/material.dart';
import '../common/config/config.dart';
import 'env_config.dart';

/// 往下共享环境配置
class ConfigWrapper extends StatelessWidget {
  final EnvConfig config;
  final Widget child;

  ConfigWrapper({
    Key key,
    this.config,
    this.child,
  });

  static EnvConfig of(BuildContext context) {
    final _InheritedConfig _inheritedConfig = context.dependOnInheritedWidgetOfExactType<_InheritedConfig>();
    return _inheritedConfig.config;
  }

  @override
  Widget build(BuildContext context) {
    // 设置 Config.DEBUG 的静态变量
    Config.DEBUG = this.config.debug;
    print("ConfigWrapper build ${Config.DEBUG}");
    return _InheritedConfig(
      config: this.config,
      child: this.child,
    );
  }
}

class _InheritedConfig extends InheritedWidget {
  const _InheritedConfig({
    Key key,
    @required this.config,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final EnvConfig config;

  @override
  bool updateShouldNotify(_InheritedConfig oldWidget) => config != oldWidget.config;
}
