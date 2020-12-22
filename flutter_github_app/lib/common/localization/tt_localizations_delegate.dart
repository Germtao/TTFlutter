import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'default_localizations.dart';

/// 多语言代理
class TTLocalizationsDelegate extends LocalizationsDelegate<TTLocalizations> {
  TTLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // 支持中文、英文
    return true;
  }

  /// 根据 locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<TTLocalizations> load(Locale locale) {
    return SynchronousFuture<TTLocalizations>(TTLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<TTLocalizations> old) {
    return false;
  }

  /// 全局静态代理
  static TTLocalizationsDelegate delegate = TTLocalizationsDelegate();
}
