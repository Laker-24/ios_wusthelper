import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//toast方法，可设置位置
showToast(String msg, {ToastGravity toastGravity, Color textColor}) {
  ToastGravity tg = toastGravity ?? ToastGravity.CENTER;
  Fluttertoast.showToast(msg: msg, gravity: tg);
}

