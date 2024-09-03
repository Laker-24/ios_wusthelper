import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';

class WlsyCard extends StatelessWidget {
  final Courses wlsyCourses;
  final int index;

  const WlsyCard({Key key, this.wlsyCourses, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> weekday = [" ", "一", "二", "三", "四", "五", "六", "日"];
    TextStyle wlsyTextStyle =
        new TextStyle(fontSize: 14.0, color: Colors.grey[600]);
    return Container(
      height: 0.12 * ScreenUtil.getInstance().screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wlsyCourses.className,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "第${wlsyCourses.startWeek.toString()}周",
                style: wlsyTextStyle,
              ),
              Text(
                "星期${weekday[wlsyCourses.weekDay]}",
                style: wlsyTextStyle,
              ),
              Text(
                "${(wlsyCourses.section * 2 - 1).toString() + (wlsyCourses.section * 2).toString()}节课",
                style: wlsyTextStyle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                wlsyCourses.classroom,
                style: wlsyTextStyle,
              ),
              Text(
                wlsyCourses.teacher,
                style: wlsyTextStyle,
              ),
            ],
          ),
          Divider(color: Colors.black54),
        ],
      ),
    );
  }
}
