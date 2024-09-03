import 'package:flutter/material.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';

class BlandCard extends StatefulWidget {
  @override
  _BlandCardState createState() => _BlandCardState();
}

class _BlandCardState extends State<BlandCard> {
  Courses course;
  List<Widget> childrenList = [
    Container(
      decoration: BoxDecoration(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        child: GestureDetector(
          onLongPress: () {
            BaseNavigator.getInstance().onJumpTo(RouteStatus.addCourse);
          },
          child: Listener(
            onPointerDown: (event) {
              setState(() {
                childrenList.add(Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.85,
                    heightFactor: 0.85,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                        )),
                  ),
                ));
              });
            },
            onPointerUp: (event) {
              setState(() {
                childrenList.removeLast();
              });
            },
            child: Stack(
              children: childrenList,
            ),
          ),
        ));
  }
}
