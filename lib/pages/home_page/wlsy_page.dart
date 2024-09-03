import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/wlsy_card.dart';

/// [物理实验课表页面]

class WlsyPage extends StatefulWidget {
  const WlsyPage({Key key}) : super(key: key);

  @override
  State<WlsyPage> createState() => _WlsyPageState();
}

class _WlsyPageState extends State<WlsyPage>
    with AutomaticKeepAliveClientMixin {
  Future _wlsyFuture;
  String stuNum;
  List<Courses> wlsyCourses = [];
  double screenHeight = ScreenUtil.getInstance().screenHeight;

  @override
  void initState() {
    super.initState();
    stuNum = JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
    _wlsyFuture = _send();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String tips = " ";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white70,
          title: Text(
            "物理实验系统",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _wlsyFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _card(
                          "学号",
                          child: Text(
                            stuNum,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20.0,
                            ),
                          ),
                        ),

                        _card(
                          "课程数目",
                          child: Text(
                            wlsyCourses.length.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            ///判断物理实验课表是否导入，若未导入则将物理实验课表添加到所有课表当中，并标记已导入
                            bool isImport = BaseCache.getInstance()
                                    .get(WlsyConst.wlsyIsImport) ??
                                false;

                            if (isImport) {
                              String tips = '已导入物理实验课表，是否需要取消导入';
                              bool needImport =
                                  await showSendDialog(context, "导入课表", tips);
                              if (needImport) {
                                cancleImport();
                                showToast("已取消导入课表");
                              }
                            }
                            //未导入则添加提示
                            else {
                              bool needImport = await showSendDialog(
                                  context, "导入课表", "是否要将物理课程导入到课表中");
                              if (needImport) {
                                try {
                                  confirmImport();
                                  showToast("物理实验课表导入成功");
                                } catch (e) {
                                  showToast("物理实验课表导入失败，请再试一次吧~");
                                }
                              }
                            }
                          },
                          child: _card("导入课表",
                              child: Icon(
                                Icons.chevron_right,
                                size: 25.0,
                                color: Colors.grey[600],
                              )),
                        ),

                        ///退出登录
                        InkWell(
                          onTap: () {
                            try {
                              cancleImport();
                              BaseCache.getInstance()
                                  .setBool(WlsyConst.wlsyIsLogin, false);
                              BaseNavigator.getInstance()
                                  .onJumpTo(RouteStatus.navigator0);
                            } catch (e) {
                              showToast("物理实验课表导入失败，请再试一次吧~");
                            }
                          },
                          child: _card(
                            "退出登录",
                            child: Icon(
                              Icons.chevron_right,
                              size: 25.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "详细课程:",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100]),
                          height: 0.55 * screenHeight,
                          child: ListView.builder(
                            itemCount: wlsyCourses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return WlsyCard(
                                wlsyCourses: wlsyCourses[index],
                              );
                            },
                          ),
                        ),
                        Align(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Center(
                                  child: Text(
                                    "物理实验课程可能与正常的课程冲突，可以点击卡片查看详细信息",
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "数据来源：武汉科技大学",
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : showLoadingDialog();
          },
        ),
      ),
    );
  }

  //请求获取物理实验课表
  Future<void> _send() async {
    String token = context.read<TokenProvider>().token;
    var result = await JwcDao.wlsySchedule(token);
    wlsyCourses = ScheduleModel.fromJson(result).data;
  }

  ///[导入物理实验课表]
  void confirmImport() {
    List<String> courses =
        BaseCache.getInstance().getStringList(JwcConst.courses);
    //取出课程所对应的颜色
    Map<String, String> getCourseAndColor =
        context.read<CoursesColorProvider>().getCourseAndColor();
    int i = 0;
    for (Courses value in wlsyCourses) {
      courses.add(json.encode(value.toJson()));
      getCourseAndColor[value.className] = CoursesColors[i];
      i++;
    }
    //添加课程

    BaseCache.getInstance().setStringList(JwcConst.courses, courses);

    //添加物理课程所对应的颜色
    context.read<CoursesColorProvider>().setCourseAndColor(getCourseAndColor);
    //物理课表设置为已导入
    BaseCache.getInstance().setBool(WlsyConst.wlsyIsImport, true);
  }

  ///[取消导入物理实验课表]
  void cancleImport() {
    //将已导入的课程删除
    List<String> courses =
        BaseCache.getInstance().getStringList(JwcConst.courses);
    int length = courses.length;
    for (int i = 0; i < length; i++) {
      for (Courses wlsy in wlsyCourses) {
        courses.removeWhere((value) => value == jsonEncode(wlsy.toJson()));
      }
    }
    //添加课程
    BaseCache.getInstance().setStringList(JwcConst.courses, courses);
    //设置物理课表为未导入状态
    BaseCache.getInstance().setBool(WlsyConst.wlsyIsImport, false);
  }

  @override
  bool get wantKeepAlive => true;
  Widget _card(String title, {Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black87, fontSize: 20.0),
          ),
          child,
        ],
      ),
    );
  }
}
