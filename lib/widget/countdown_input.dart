import 'package:flutter/material.dart';

class CountdownInput extends StatefulWidget {
  /// 左部提示文字
  final String title;
  //字体样式
  final TextStyle countdownTextStyle;

  /// 输入框内容变化
  final ValueChanged<String> onChanged;

  /// 输入框提示文字
  final String hint;

  final TextEditingController controller;

  CountdownInput(
      {Key key,
      this.countdownTextStyle,
      this.onChanged,
      this.title,
      this.controller,
      this.hint})
      : super(key: key);

  @override
  _CountdownInputState createState() => _CountdownInputState();
}

class _CountdownInputState extends State<CountdownInput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 10.0),
      child: Row(
        children: [
          Text(
            widget.title,
            style: widget.countdownTextStyle,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  border: InputBorder.none, //去掉下划线
                  hintText: widget.hint,
                  hintStyle: TextStyle(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00FF0000)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
