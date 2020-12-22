import 'package:flutter/material.dart';
import 'tt_string_base.dart';
import 'tt_string_en.dart';
import 'tt_string_zh.dart';

/// 自定义多语言实现
class TTLocalizations {
  final Locale locale;

  TTLocalizations(this.locale);

  /// 根据不同 locale.languageCode 加载不同语言对应
  /// TTStringEn 和 TTStringZh 都继承了 TTStringBase
  static Map<String, TTStringBase> _localizedValues = {
    'en': TTStringEn(),
    'zh': TTStringZh(),
  };

  TTStringBase get currentLocalized {
    if (_localizedValues.containsKey(locale.languageCode)) {
      return _localizedValues[locale.languageCode];
    }
    return _localizedValues['en'];
  }

  /// 通过 Localizations 加载当前 TTLocalizations
  /// 获取对应的 TTStringBase
  static TTLocalizations of(BuildContext context) {
    return Localizations.of(context, TTLocalizations);
  }

  /// 通过 Localizations 加载当前 TTLocalizations
  /// 获取对应的 TTStringBase
  static TTStringBase i18n(BuildContext context) {
    return (Localizations.of(context, TTLocalizations) as TTLocalizations).currentLocalized;
  }
}
