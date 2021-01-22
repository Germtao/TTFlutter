import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_github_app/app.dart';
import 'package:flutter_github_app/env/config_wrapper.dart';
import 'package:flutter_github_app/env/env_config.dart';
import 'package:flutter_github_app/env/env_dev.dart';
import 'package:flutter_github_app/page/common/error_page.dart';

void main() {
  runZoned(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return ErrorPage(
        details.exception.toString() + "\n " + details.stack.toString(),
        details,
      );
    };
    runApp(
      ConfigWrapper(
        child: FlutterReduxApp(),
        config: EnvConfig.fromJson(config),
      ),
    );
  }, onError: (Object object, StackTrace stack) {
    print(object);
    print(stack);
  });
}
