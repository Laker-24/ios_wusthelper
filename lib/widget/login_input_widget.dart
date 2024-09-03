import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef Onfocous = Function();
typedef LoseFocous = Function();

/// 自定义登陆输入框
class LoginInput extends StatefulWidget {
  /// 左部提示文字
  final String title;

  /// 输入框提示文字
  final String hint;

  /// 默认填充
  final String initValue;

  /// 输入框内容变化
  final ValueChanged<String> onChanged;

  /// 焦点变化
  final ValueChanged<bool> focusChaged;

  /// 是否启用密码输入
  bool obscureText;

  /// 键盘输入类型
  final TextInputType keyboardType;

  /// 回车时的动作
  final TextInputAction textInputAction;

  /// 获取焦点时的回调
  final Onfocous onfocous;

  /// 失去焦点的回调
  final LoseFocous loseFocous;

  final TextEditingController controller;

  LoginInput(
    this.title,
    this.hint, {
    Key key,
    this.onChanged,
    this.focusChaged,
    this.obscureText = false,
    this.keyboardType,
    this.initValue,
    this.textInputAction,
    this.onfocous,
    this.controller,
    this.loseFocous,
  }) : super(key: key);
  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();
  LoseFocous _loseFocous;
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _loseFocous = widget.loseFocous ?? () {};
    // 判断是否获取到了焦点
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.onfocous != null) {
        widget.onfocous();
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      }
      if (!_focusNode.hasFocus) {
        _loseFocous();
      }

      // if (widget.focusChaged != null) {
      //   widget.focusChaged(_focusNode.hasFocus);
      // }
    });
    // if (_focusNode == null) {
    //   _focusNode.addListener(() {
    //     widget.onfocous();
    //     if (widget.focusChaged != null) {
    //       widget.focusChaged(_focusNode.hasFocus);
    //     }
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              width: 100,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      autofocus: !widget.obscureText,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      // onEditingComplete: () => FocusManager.instance.primaryFocus.unfocus(),
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      controller: widget.controller ?? _controller,
      style: TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          //判断是否为密码输入
          suffix: widget.obscureText == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.brown,
                  ),
                )
              : null),
    ));
  }
}

