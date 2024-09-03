import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/graduate_stu_info_model.dart';
import 'package:wust_helper_ios/model/jwc_info_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';

class StudentInfoPage extends StatelessWidget {
  const StudentInfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil.getInstance().screenHeight;
    int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
    // int loginIndex = 0;
    String stuName = ''; //学生名字
    String major = ''; //专业
    String academy = ''; //学院
    String degree = ''; //学位
    String tutorName = ''; //导师姓名
    if (loginIndex == 0) {
      InfoData infoData = InfoData.fromJson(
          jsonDecode(BaseCache.getInstance().get(JwcConst.info)));
      stuName = infoData.stuName;
      major = infoData.major;
      academy = infoData.college;
    } else if (loginIndex == 1) {
      GraduateStuInfoData data = GraduateStuInfoData.fromJson(
          jsonDecode(BaseCache.getInstance().get(JwcConst.info)));
      stuName = data.name;
      degree = data.degree;
      academy = data.academy;
      major = data.specialty;
      tutorName = data.tutorName;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // if (loginIndex == 0)
            //   BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator4);
            // else if (loginIndex == 1)
            //   BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator3);
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: Text(
          "信息预览",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: 30.0, left: 0.02 * screenHeight, right: 0.02 * screenHeight),
        child: SizedBox(
          height: 0.4 * screenHeight,
          child: Column(
            children: [
              _card("昵称", stuName),
              _card("专业", major),
              _card("院系", academy),
              loginIndex == 1 ? _card("学位", degree) : Container(),
              loginIndex == 1 ? _card("导师姓名", tutorName) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  _card(String title, String content) {
    return Container(
      height: 0.07 * ScreenUtil.getInstance().screenHeight,
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              Text(
                content,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ],
          ),
          Divider(
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}
