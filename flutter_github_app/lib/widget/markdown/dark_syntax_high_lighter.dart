import 'package:flutter/material.dart';

abstract class SyntaxCustomHightlighter {
  TextSpan format(String src);
}

class DarkSyntaxHighlighter extends SyntaxCustomHightlighter {
  @override
  TextSpan format(String src) {
    // TODO: implement format
    throw UnimplementedError();
  }
}

class SyntaxHighlighterStyle {
  final TextStyle baseStyle;
  final TextStyle numberStyle;
  final TextStyle commentStyle;
  final TextStyle keywordStyle;
  final TextStyle stringStyle;
  final TextStyle punctuationStyle;
  final TextStyle classStyle;
  final TextStyle constantStyle;

  SyntaxHighlighterStyle({
    this.baseStyle,
    this.numberStyle,
    this.commentStyle,
    this.keywordStyle,
    this.stringStyle,
    this.punctuationStyle,
    this.classStyle,
    this.constantStyle,
  });

  static SyntaxHighlighterStyle defaultStyle() {
    return SyntaxHighlighterStyle(
      baseStyle: TextStyle(color: Color.fromRGBO(212, 212, 212, 1.0)),
      numberStyle: TextStyle(color: Colors.blue[800]),
      commentStyle: TextStyle(color: Color.fromRGBO(124, 126, 120, 1.0)),
      keywordStyle: TextStyle(color: Color.fromRGBO(228, 125, 246, 1.0)),
      stringStyle: TextStyle(color: Color.fromRGBO(150, 190, 118, 1.0)),
      punctuationStyle: TextStyle(color: Color.fromRGBO(212, 212, 212, 1.0)),
      classStyle: TextStyle(color: Color.fromRGBO(150, 190, 118, 1.0)),
      constantStyle: TextStyle(color: Colors.brown[500]),
    );
  }
}
