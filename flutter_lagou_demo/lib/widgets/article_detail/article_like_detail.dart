import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:flutter_lagou_demo/styles/text_styles.dart';import '../models/like_num_model.dart';/// 帖子详情页的赞组件////// 包括点赞组件 icon ，以及组件点击效果/// 点赞数量class ArticleDetailLike extends StatelessWidget {  @override  Widget build(BuildContext context) {    final likeNumModel = Provider.of<LikeNumModel>(context);    return Column(      crossAxisAlignment: CrossAxisAlignment.center,      children: [        FlatButton(          child: Icon(Icons.thumb_up, color: Colors.grey, size: 40),          onPressed: () => likeNumModel.like(),        ),        Text(          '${likeNumModel.value}',          style: TextStyles.commonStyle(),        ),      ],    );  }}