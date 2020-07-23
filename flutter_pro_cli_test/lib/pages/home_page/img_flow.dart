import 'package:flutter/material.dart';

import 'package:flutter_pro_cli_test/api/content/index.dart';
import 'package:flutter_pro_cli_test/util/struct/content_detail.dart';
import 'package:flutter_pro_cli_test/util/struct/api_ret_info.dart';
import 'package:flutter_pro_cli_test/widgets/home_page/img_card.dart';

/// 九宫格首页
class HomePageImgFlow extends StatefulWidget {
  const HomePageImgFlow({Key key}) : super(key: key);

  @override
  _HomePageImgFlowState createState() => _HomePageImgFlowState();
}

/// 首页推荐帖子列表
class _HomePageImgFlowState extends State<HomePageImgFlow> {
  /// 首页推荐帖子列表
  List<StructContentDetail> contentList;

  @override
  void initState() {
    super.initState();
    // 拉取推荐内容
    setState(() {
      StructApiContentListRetInfo retInfo =
          ApiContentIndex().getRecommendList();
      contentList = retInfo.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<StructContentDetail> tmpList = [];

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        if (position % 3 == 0) {
          // 起始位置，初始赋值
          tmpList = [this.contentList[position]];
        } else {
          // 非初始，则插入列表
          tmpList.add(this.contentList[position]);
        }

        // 判断数据插入时机，如果最后一组或者满足三个一组则插入
        if (position == contentList.length - 1 || (position + 1) % 3 == 0) {
          return ImgCard(
            position: position,
            articleInfoList: tmpList,
            isLast:
                position == contentList.length - 1, // 确认是否为最后数据，最后数据无需处理大小图问题
          );
        }

        return Container();
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: .1,
          color: Color(0xFFDDDDDD),
        );
      },
      itemCount: contentList.length,
    );
  }
}
