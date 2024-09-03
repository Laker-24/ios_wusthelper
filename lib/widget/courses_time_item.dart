import 'package:flutter/material.dart';
import 'package:wust_helper_ios/util/color_util.dart';

class CoursesTimeItem extends StatelessWidget {
  final List<String> timeList;
  final int index;
  const CoursesTimeItem(
    this.timeList,
    this.index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${timeList[index * 2]}',
                style: TextStyle(fontSize: 10),
              ),
              Text('|'),
              Text(
                '${timeList[index * 2 + 1]}',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(-0.5, 1000),
              color: Colors.black87,
            )
          ],
          // color: Color(transformColor('C8', '#ffffff')),
          // color: Colors.white
          // border: Border.all(color: Colors.black12, width: 0.5),
          border: Border(
            // bottom: BorderSide(color: Colors.black12, width: 0.5),
            right: BorderSide(color: Colors.black12, width: 0.5),
          ),
        ));
  }
}
