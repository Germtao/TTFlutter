import 'package:flutter/material.dart';import 'package:flutter_lagou_demo/widgets/common/banner_info.dart';import 'package:flutter_lagou_demo/widgets/models/like_num_model.dart';import 'package:flutter_test/flutter_test.dart';import 'package:image_test_utils/image_test_utils.dart';import 'package:provider/provider.dart';import 'package:flutter_lagou_demo/widgets/models/user_info.dart';import 'package:flutter_lagou_demo/widgets/models/article_info.dart';import 'package:flutter_lagou_demo/widgets/home_page/article_summary.dart';import 'package:flutter_lagou_demo/widgets/home_page/article_bottom_bar.dart';import 'package:flutter_lagou_demo/widgets/home_page/article_like_bar.dart';import 'package:flutter_lagou_demo/widgets/home_page/article_card.dart';void main() {  final String bannerImage = 'https://img.089t.com/content/20200227/osbbw9upeelfqnxnwt0glcht.jpg';  final UserInfo userInfo = UserInfo('test', 'https://i.pinimg.com/originals/1f/00/27/1f0027a3a80f470bcfa5de596507f9f4.png');  final ArticleInfo articleInfo = ArticleInfo(      '你好，交个朋友',      '我是一个小可爱，很长的一个测试看看效果，会换行吗',      'https://i.pinimg.com/originals/e0/64/4b/e0644bd2f13db50d0ef6a4df5a756fd9.png',      20,      30  );  final LikeNumModel likeNumModel = LikeNumModel();  testWidgets('test article card', (WidgetTester tester) async {    provideMockedNetworkImages(() async {      final Widget testWidgets = ArticleCard(userInfo: userInfo, articleInfo: articleInfo);      await tester.pumpWidget(        new Provider<int>.value(          child: ChangeNotifierProvider.value(            value: likeNumModel,            child: MaterialApp(              home: testWidgets,            ),          ),        )      );      expect(find.byWidget(testWidgets), findsOneWidget);    });  });}