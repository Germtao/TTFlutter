import 'package:flutter/material.dart';
import 'package:flutter_github_app/common/localization/default_localizations.dart';
import 'package:flutter_github_app/common/style/style.dart';
import 'package:flutter_github_app/widget/input/tt_input_widget.dart';
import 'package:flutter_github_app/widget/card/tt_card_item.dart';

/// issue 编辑输入框
class IssueEditDialog extends StatefulWidget {
  final String dialogTitle;

  final ValueChanged<String> onTitleChanged;

  final ValueChanged<String> onContentChanged;

  final VoidCallback onPressed;

  final TextEditingController titleController;

  final TextEditingController valueController;

  final bool needTitle;

  IssueEditDialog(
    this.dialogTitle,
    this.onTitleChanged,
    this.onContentChanged,
    this.onPressed, {
    this.titleController,
    this.valueController,
    this.needTitle = true,
  });

  @override
  _IssueEditDialogState createState() => _IssueEditDialogState();
}

class _IssueEditDialogState extends State<IssueEditDialog> {
  /// 标题输入框
  _renderTitleInput() {
    return widget.needTitle
        ? Padding(
            padding: EdgeInsets.all(5.0),
            child: TTInputWidget(
              onChanged: widget.onTitleChanged,
              controller: widget.titleController,
              hintText: TTLocalizations.i18n(context).issueEditIssueTitleTip,
              obscureText: false,
            ),
          )
        : Container();
  }

  /// 快速输入框
  _renderFastInput() {
    return Container(
      height: 30.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FAST_INPUT_LIST.length,
        itemBuilder: (BuildContext context, int index) {
          return RawMaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.only(left: 8.0, top: 5.0, right: 8.0, bottom: 5.0),
            constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            child: Icon(
              FAST_INPUT_LIST[index].iconData,
              size: 16.0,
            ),
            onPressed: () {
              String text = FAST_INPUT_LIST[index].content;
              String newText = '';
              if (widget.valueController.value != null) {
                newText = widget.valueController.value.text;
              }
              newText = newText + text;
              setState(() {
                widget.valueController.value = TextEditingValue(text: newText);
              });
              widget.onContentChanged?.call(newText);
            },
          );
        },
      ),
    );
  }

  /// 内容输入框
  _renderContentInput() {
    return Container(
      height: MediaQuery.of(context).size.width * 3 / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: TTColors.white,
        border: Border.all(color: TTColors.subTextColor, width: .3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              autofocus: false,
              maxLines: 999,
              onChanged: widget.onContentChanged,
              controller: widget.valueController,
              decoration: InputDecoration(
                hintText: TTLocalizations.i18n(context).issueEditIssueTitleTip,
                hintStyle: TTConstant.middleSubText,
                isDense: true,
                border: InputBorder.none,
              ),
              style: TTConstant.middleText,
            ),
          ),

          /// 快速输入框
          _renderFastInput(),

          Container(height: 10.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(4.0),
                  constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                  child: Text(
                    TTLocalizations.i18n(context).appCancel,
                    style: TTConstant.normalSubText,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                width: 0.3,
                height: 25.0,
                color: TTColors.subTextColor,
              ),
              Expanded(
                child: RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(4.0),
                  constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                  child: Text(
                    TTLocalizations.i18n(context).appOk,
                    style: TTConstant.normalTextBold,
                  ),
                  onPressed: widget.onPressed,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black12,
            // 触摸收起键盘
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Center(
                child: TTCardItem(
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // dialog 标题
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                          child: Center(
                            child: Center(
                              child: Text(
                                widget.dialogTitle,
                                style: TTConstant.normalTextBold,
                              ),
                            ),
                          ),
                        ),

                        // 标题输入框
                        _renderTitleInput(),

                        // 内容输入框
                        _renderContentInput(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
var FAST_INPUT_LIST = [
  FastInputIconModel(TTIcons.ISSUE_EDIT_H1, '\n# '),
  FastInputIconModel(TTIcons.ISSUE_EDIT_H2, '\n## '),
  FastInputIconModel(TTIcons.ISSUE_EDIT_H3, '\n### '),
  FastInputIconModel(TTIcons.ISSUE_EDIT_BOLD, '****'),
  FastInputIconModel(TTIcons.ISSUE_EDIT_ITALIC, '__'),
  FastInputIconModel(TTIcons.ISSUE_EDIT_QUOTE, '` `'),
  FastInputIconModel(TTIcons.ISSUE_EDIT_CODE, ' \n``` \n\n``` \n'),
  FastInputIconModel(TTIcons.ISSUE_EDIT_LINK, '[](url)'),
];

class FastInputIconModel {
  final IconData iconData;
  final String content;

  FastInputIconModel(this.iconData, this.content);
}
