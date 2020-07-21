import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pro_cli_test/pages/user_page/index.dart';

// @todo
void main() {
  testWidgets('test flutter_pro_cli_test/pages/user_page/index.dart', (WidgetTester tester) async {
     final Widget testWidgets = UserPageIndex();
      await tester.pumpWidget(
          new MaterialApp(
              home: testWidgets
          )
      );

      expect(find.byWidget(testWidgets), findsOneWidget);
  });
}