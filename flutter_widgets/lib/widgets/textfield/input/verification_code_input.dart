import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './code_input_builder.dart';

class VerificationCodeInput extends StatefulWidget {
  /// 始终显示的字符实体的长度
  final int length;

  /// 显示的 keyboard 类型
  final TextInputType keyboardType;

  /// 可以验证文本的输入格式器列表
  final List<TextInputFormatter> inputFormatters;

  /// 字符实体的构建器
  ///
  /// 示例查看 [CodeInputBuilders]
  final CodeInputBuilder builder;

  /// 用于更改输入的回调
  final void Function(String value) onChanged;

  /// 输入填充时的回调
  final void Function(String value) onFilled;

  /// 由于 MediaQuery.of(widget.ctx) 而导致上下文父级
  final BuildContext ctx;

  /// 一个帮助函数，用于为给定的长度和长度创建输入格式化程序 keyboardType
  static List<TextInputFormatter> _createInputFormatters(int length, TextInputType keyboardType) {
    final formatters = <TextInputFormatter>[LengthLimitingTextInputFormatter(length)];

    if (keyboardType == TextInputType.number) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    return formatters;
  }

  const VerificationCodeInput._({
    Key key,
    @required this.length,
    @required this.keyboardType,
    @required this.inputFormatters,
    @required this.builder,
    @required this.ctx,
    this.onChanged,
    this.onFilled,
  }) : super(key: key);

  factory VerificationCodeInput({
    Key key,
    @required int length,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter> inputFormatters,
    BuildContext ctx,
    @required CodeInputBuilder builder,
    void Function(String value) onChanged,
    void Function(String value) onFilled,
  }) {
    assert(length != null);
    assert(length > 0, 'The length needs to be larger than zero.');
    assert(length.isFinite, 'The length needs to be finite.');
    assert(keyboardType != null);
    assert(builder != null, 'The builder is required for rendering the character segments.');

    inputFormatters ??= _createInputFormatters(length, keyboardType);

    return VerificationCodeInput._(
      key: key,
      length: length,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      builder: builder,
      ctx: ctx,
      onChanged: onChanged,
      onFilled: onFilled,
    );
  }

  @override
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final node = FocusNode();
  final controller = TextEditingController();

  String get text => controller.text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 0.0,
          height: 0.0,
          child: EditableText(
            controller: controller,
            focusNode: node,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            backgroundCursorColor: Colors.black,
            style: TextStyle(),
            cursorColor: Colors.black,
            onChanged: (value) {
              setState(() {
                widget.onChanged?.call(value);
                if (value.length == widget.length) {
                  widget.onFilled?.call(value);
                }
              });
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            if (MediaQuery.of(widget.ctx).viewInsets.bottom == 0) {
              final focusScope = FocusScope.of(context);
              focusScope.requestFocus(FocusNode());
              Future.delayed(Duration.zero, () => focusScope.requestFocus(node));
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.length, (index) {
                final hasFocus = controller.selection.start == index;
                final char = index < text.length ? text[index] : '';
                final characterEntity = widget.builder(hasFocus, char);

                assert(
                    characterEntity != null,
                    'The builder for the character entity at position $index '
                    'returned null. It did${hasFocus ? ' not' : ''} have the '
                    'focus and the character passed to it was \'$char\'.');

                return characterEntity;
              }),
            ),
          ),
        )
      ],
    );
  }
}
