import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_messages.dart' as messages_messages;
import 'messages_zh_CN.dart' as messages_zh_CN;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'messages': () => Future.value(null), // ignore: unnecessary_new
  'zh_CN': () => Future.value(null), // ignore: unnecessary_new
};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'messages': return messages_messages.messages;
    case 'zh_CN': return messages_zh_CN.messages;
    default: return null;
  }
}

/// 用户程序应在使用[localeName]发送消息之前调用此方法
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
    localeName,
    (locale) => _deferredLibraries[locale] != null,
    onFailure: (_) => null
  );

  if (availableLocale != null) {
    return Future.value(false); // ignore: unnecessary_new
  }

  var lib = _deferredLibraries[availableLocale];

  // ignore: unnecessary_new
  await (lib == null ? Future.value(false) : lib());
  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    print('_messagesExistFor Error: $e');
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}