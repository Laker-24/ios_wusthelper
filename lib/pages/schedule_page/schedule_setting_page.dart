import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/util/popup_ios_selection.dart';

enum ScheduleSettingChoice {
  changeCurrentWeek,
  // changeCurrentTerm,
}

class ScheduleSetting extends StatefulWidget {
  const ScheduleSetting({Key key}) : super(key: key);

  @override
  State<ScheduleSetting> createState() => _ScheduleSettingState();
}

class _ScheduleSettingState extends State<ScheduleSetting> {
  String tips =
      '''1. 课表数据源于教务处，如果武科大助手课程与教务处冲突，请以教务处为准
  2.武科大助手默认是周一为第一天，在显示周日的课程时，开始周和结束周都在真实数据上减一
  3.这样的操作不会导致课程的上课时间显示错误
  4.选择周日为第一天，则周日课程周数显示与教务处一致
''';

  @override
  Widget build(BuildContext context) {
    ///获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;

    ///查看当前每周第一天是否为周一
    CurrentWeekProvider currentWeekProvider =
        context.read<CurrentWeekProvider>();
    bool isMonday = currentWeekProvider.currentWeekIsMonday();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("日程设置"),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showSingleDialog(context, "课表设置说明", tips);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            ///[设置周日为每周第一天]
            Center(
              child: card(
                "设置周日为每周第一天", ScheduleSettingChoice.changeCurrentWeek,
                //iOS风格的switch开关
                CupertinoSwitch(
                  value: !isMonday,
                  onChanged: (value) {
                    setState(() {
                      currentWeekProvider.setCurrentWeekIsMonday(
                          !currentWeekProvider.currentWeekIsMonday());
                    });
                  },
                  activeColor: Colors.green[300],
                  trackColor: Colors.grey[400],
                ),
                width: 0.95 * screenWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //小卡片 【是否设置当前周为周日】
  card(String title, ScheduleSettingChoice choice, Widget child,
      {double width, double value}) {
    switch (choice) {
      case ScheduleSettingChoice.changeCurrentWeek:
        return Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Container(
            width: width,
            height: 0.12 * width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
        break;
    }
  }
}
