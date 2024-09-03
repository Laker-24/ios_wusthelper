import 'package:flutter/material.dart';

///设计自定义悬浮Button

///倒计时的悬浮Button
Widget countdownFloatingActionButton(Function onPressed) {
  return SizedBox(
    height: 50,
    width: 50,
    child: FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white.withOpacity(0.0),
      elevation: 0,
      child: Icon(
        Icons.add_circle_outline_outlined,
        size: 80.0,
        color: Colors.orange,
      ),
    ),
  );
}

//可设置悬浮Button的Location(可复用)
class CountdownFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CountdownFloatingActionButtonLocation(
      this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
