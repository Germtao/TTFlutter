import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// markdown控件
class MarkdownWidget extends StatelessWidget {
  static const int DARK_WHITE = 0;
  static const int DARK_LIGHT = 1;
  static const int DARK_THEME = 2;

  final String markdownData;
  final int style;

  MarkdownWidget({this.markdownData = '', this.style = DARK_WHITE});

  MarkdownStyleSheet _getCommonSheet(BuildContext context, Color codeBackground) {
    MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context));
    return markdownStyleSheet
        .copyWith(
          codeblockDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: codeBackground,
            border: Border.all(color: TTColors.subTextColor, width: 0.3),
          ),
        )
        .copyWith(
          blockquoteDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: TTColors.subTextColor,
            border: Border.all(color: TTColors.subTextColor, width: 0.3),
          ),
          blockquote: TTConstant.smallTextWhite,
        );
  }

  MarkdownStyleSheet _getStyleSheetDark(BuildContext context) {
    return _getCommonSheet(
      context,
      Color.fromRGBO(40, 44, 52, 1.0),
    ).copyWith(
      p: TTConstant.smallTextWhite,
      h1: TTConstant.largeLargeTextWhite,
      h2: TTConstant.largeTextWhiteBold,
      h3: TTConstant.normalTextMitWhiteBold,
      h4: TTConstant.middleTextWhite,
      h5: TTConstant.smallTextWhite,
      h6: TTConstant.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: TTConstant.middleTextWhiteBold,
      code: TTConstant.smallSubText,
    );
  }

  MarkdownStyleSheet _getStyleSheetWhite(BuildContext context) {
    return _getCommonSheet(
      context,
      Color.fromRGBO(40, 44, 52, 1.0),
    ).copyWith(
      p: TTConstant.smallText,
      h1: TTConstant.largeLargeText,
      h2: TTConstant.largeTextBold,
      h3: TTConstant.normalTextBold,
      h4: TTConstant.middleText,
      h5: TTConstant.smallText,
      h6: TTConstant.smallText,
      strong: TTConstant.middleTextBold,
      code: TTConstant.smallSubText,
    );
  }

  MarkdownStyleSheet _getStyleSheetTheme(BuildContext context) {
    return _getCommonSheet(
      context,
      Color.fromRGBO(40, 44, 52, 1.0),
    ).copyWith(
      p: TTConstant.smallTextWhite,
      h1: TTConstant.largeLargeTextWhite,
      h2: TTConstant.largeTextWhiteBold,
      h3: TTConstant.normalTextMitWhiteBold,
      h4: TTConstant.middleTextWhite,
      h5: TTConstant.smallTextWhite,
      h6: TTConstant.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: TTConstant.middleTextWhiteBold,
      code: TTConstant.smallSubText,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    Color background = TTColors.white;
    switch (style) {
      case DARK_LIGHT:
        background = TTColors.primaryLightValue;
        break;
      case DARK_THEME:
        background = Theme.of(context).primaryColor;
        break;
    }
    return background;
  }

  MarkdownStyleSheet _getStyleSheet(BuildContext context) {
    var styleSheet = _getStyleSheetWhite(context);
    switch (style) {
      case DARK_LIGHT:
        styleSheet = _getStyleSheetDark(context);
        break;
      case DARK_THEME:
        styleSheet = _getStyleSheetTheme(context);
        break;
    }
    return styleSheet;
  }

  _getMarkdownData(String data) {
    /// 优化图片显示
    RegExp regExp = RegExp(r'!\[.*\]\((.+)\)');
    RegExp regExpImg = RegExp("<img.*?(?:>|\/>)");
    RegExp regExpSrc = RegExp("src=[\'\"]?([^\'\"]*)[\'\"]?");

    String mdDataCode = data;
    try {
      Iterable<Match> tags = regExp.allMatches(data);
      if (tags != null && tags.length > 0) {
        for (Match m in tags) {
          String imageMatch = m.group(0);
          if (imageMatch != null && !imageMatch.contains(".svg")) {
            String match = imageMatch.replaceAll("\)", "?raw=true");
            if (!match.contains(".svg") && match.contains("http")) {
              /// 增加点击
              String src = match.replaceAll(RegExp(r'!\[.*\]\('), '').replaceAll(")", "");
              String actionMatch = "[$match]($src)";
              match = actionMatch;
            } else {
              match = "";
            }
            mdDataCode = mdDataCode.replaceAll(m.group(0), "");
          }
        }
      }

      /// 优化 img 标签的 src 资源
      tags = regExpImg.allMatches(data);
      if (tags != null && tags.length > 0) {
        for (Match m in tags) {
          String imgTag = m.group(0);
          String match = imgTag;
          if (imgTag != null) {
            Iterable<Match> srcTags = regExpSrc.allMatches(imgTag);
            for (Match srcM in srcTags) {
              String srcStr = srcM.group(0);
              if (srcStr != null && srcStr.contains("http")) {
                String newSrc = srcStr.substring(srcStr.indexOf("http"), srcStr.length - 1) + "?raw=true";

                /// 增加点击
                match = "[![]($newSrc)]($newSrc)";
              }
            }
          }
          mdDataCode = mdDataCode.replaceAll(imgTag, match);
        }
      }
    } catch (e) {
      print('get markdown data error: ${e.toString()}');
    }
    return mdDataCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
