import 'package:flutter/material.dart';import 'package:flutter_test/flutter_test.dart';import 'package:image_test_utils/image_test_utils.dart';import 'package:flutter_lagou_demo/widgets/models/user_info.dart';import 'package:flutter_lagou_demo/widgets/models/comment_info.dart';import 'package:flutter_lagou_demo/widgets/article_detail/article_detail_comment.dart';void main() {  /// comment 详情  final List<CommentInfo> commentList = [    CommentInfo(UserInfo('Flutter_1', 'https://i.pinimg.com/originals/1f/00/27/1f0027a3a80f470bcfa5de596507f9f4.png'), 'test_1'),    CommentInfo(UserInfo('Flutter_2', 'https://i.pinimg.com/originals/1f/00/27/1f0027a3a80f470bcfa5de596507f9f4.png'), 'test_2'),    CommentInfo(UserInfo('Flutter_3', 'https://i.pinimg.com/originals/1f/00/27/1f0027a3a80f470bcfa5de596507f9f4.png'), 'test_3'),  ];  testWidgets('test detail comment', (WidgetTester tester) async {    provideMockedNetworkImages(() async {      final Widget testWidgets = ArticleDetailComments(commentList: commentList);      await tester.pumpWidget(        new MaterialApp(          home: testWidgets,        )      );      expect(find.text(commentList[0].userInfo.nickname), findsOneWidget);      expect(find.text(commentList[0].comment), findsOneWidget);      expect(find.text(commentList[1].userInfo.nickname), findsOneWidget);      expect(find.text(commentList[1].comment), findsOneWidget);            expect(find.byWidget(testWidgets), findsOneWidget);    });  });}