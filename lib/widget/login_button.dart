import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback onPressed;
  final Color color;
  LoginButton(this.title, this.enable, this.onPressed, {this.color});
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 45,
        onPressed: enable ? onPressed : null,
        disabledColor: Colors.grey,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        color: color ?? Colors.green,
      ),
    );
  }
}
