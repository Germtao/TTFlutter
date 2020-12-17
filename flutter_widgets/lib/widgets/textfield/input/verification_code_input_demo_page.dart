import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/textfield/input/code_input_builder.dart';
import 'package:flutter_widgets/widgets/textfield/input/verification_code_input.dart';

/// 验证码输入框
class VerificationCodeInputDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VerificationCodeInputDemoPage'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          child: Center(
            child: VerificationCodeInput(
              ctx: context,
              length: 6,
              keyboardType: TextInputType.number,
              builder: staticRectangle(context),
              onChanged: (value) => print('on changed ${value ?? ''}'),
              // 输入完成时
              onFilled: (value) => print('on Filled: ${value ?? ''}'),
            ),
          ),
        ),
      ),
    );
  }

  staticRectangle(BuildContext context) {
    var codeSize = 6;
    double padding = 16;
    double width = MediaQuery.of(context).size.width;
    double codeFullSize = (width - 2 * padding) / codeSize;
    double codeNormalSize = codeFullSize - 20;
    return CodeInputBuilders.rectangle(
      totalSize: Size(codeFullSize, codeFullSize),
      emptySize: Size(codeNormalSize, codeNormalSize),
      filledSize: Size(codeNormalSize, codeNormalSize),
      borderRadius: BorderRadius.zero,
      border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
      color: Colors.transparent,
      textStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }
}
