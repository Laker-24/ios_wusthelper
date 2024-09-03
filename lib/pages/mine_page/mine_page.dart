import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/graduate_stu_info_model.dart';
import 'package:wust_helper_ios/model/jwc_combine_model.dart';
import 'package:wust_helper_ios/model/jwc_info_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/widget/index_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  MediaQueryData mediaQueryData;
  String stuName = ' ';
  String stuNum = ' ';
  List<Function> handleTaps;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    mediaQueryData = MediaQuery.of(context);
    // 卡片长宽以屏幕宽度为基准
    double screenWidth = mediaQueryData.size.width;
    handleTaps = [
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.feedback),
      () => launchQQ(),
      () => checkUpdate(),
      () => BaseNavigator.getInstance().onJumpTo(RouteStatus.about),
    ];
    return FutureBuilder(
      future: initStuInfo(),
      builder: (context, snapshot) {
        return SafeArea(
            child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              body: snapshot.connectionState == ConnectionState.done
                  ? Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          /// [Title]
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    Baseline(
                                      baseline: 30,
                                      baselineType: TextBaseline.ideographic,
                                      child: Text(
                                        '我的',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.015 * 4,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Baseline(
                                        baseline: 30,
                                        baselineType: TextBaseline.alphabetic,
                                        child: Text(
                                          'Mine',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.015 * 3,
                                              color: Colors.black45),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// [头像][信息][退出登录]
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.015 * 10,
                                height: screenWidth * 0.015 * 10,
                                child: InkWell(
                                  onTap: () {
                                    BaseNavigator.getInstance()
                                        .onJumpTo(RouteStatus.info);
                                  },
                                  child: Image.asset(
                                    'assets/images/avatar.png',
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                        stuName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.015 * 4.5,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      stuNum,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.015 * 3.2,
                                          color: Colors.black26),
                                    ),
                                  ],
                                ),
                              )),

                              // TODO: 确认注销
                              // 注销后您手动添加的课程和设置的考试倒计时将会被删除和取消，确认注销吗？
                              IndexCard(
                                  screenWidth * 0.23,
                                  screenWidth * 0.4 * 0.26,
                                  '#ff505a',
                                  Center(
                                    child: Text(
                                      '退出登录',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ), () {
                                BaseNavigator.getInstance()
                                    .onJumpTo(RouteStatus.login);
                                BaseCache.getInstance().clear();
                              })
                            ],
                          ),

                          /// [小工具]
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 50 / 23),
                              itemBuilder: (context, index) {
                                return _smallCard(screenWidth, index);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  BaseNavigator.getInstance()
                                      .onJumpTo(RouteStatus.settingPage);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                icon: Icon(Icons.settings),
                                label: Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "设置",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.015 * 3,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(Icons.chevron_right)
                                    ],
                                  ),
                                )),
                          ),
                          Text("领航工作室出品")
                        ],
                      ))
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
        ));
      },
    );
  }

  initStuInfo() async {
    int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
    if (loginIndex == 0) {
      InfoData stuInfo = InfoData.fromJson(
          json.decode(await BaseCache.getInstance().get(JwcConst.info)));
      stuName = stuInfo.stuName;
      stuNum = stuInfo.stuNum;
    } else if (loginIndex == 1) {
      Map<String, dynamic> data =
          json.decode(await BaseCache.getInstance().get(JwcConst.info));
      GraduateStuInfoData infoData = GraduateStuInfoData.fromJson(data);
      //姓名和学号
      stuName = infoData.name;
      stuNum = JhEncryptUtils.aesDecrypt(
          BaseCache.getInstance().get(ConstList.STU_NUM));
    }
  }

  List<String> smallCardContents = [
    '提交反馈',
    'QQ用户群',
    '检查更新',
    '关于软件',
    '建议或吐槽',
    '参与助手内测',
    'App Store商店',
    '武科大助手'
  ];

  List<String> smallCardImages = [
    'assets/images/feedback.png',
    'assets/images/qqgroup.png',
    'assets/images/update.png',
    'assets/images/about.png'
  ];
  Widget _smallCard(double screenWidth, int index) {
    return Padding(
      padding: index % 2 == 0
          ? EdgeInsets.only(right: 12, bottom: 15)
          : EdgeInsets.only(left: 12, bottom: 15),
      child: IndexCard(
          screenWidth * 0.42,
          screenWidth * 0.42 * 0.5,
          // "#000",
          '#ffffff',
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(smallCardImages[index]),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      smallCardContents[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.015 * 3,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      smallCardContents[index + 4],
                      style: TextStyle(color: Colors.black38),
                    )
                  ],
                ))
              ],
            ),
          ),
          handleTaps[index]),
    );
  }

  void launchQQ() async => await canLaunch(ConstList.QQ_URL)
      ? await launch(ConstList.QQ_URL)
      : await showSendDialog(
          context, 'QQ唤起异常', '也许是您没有装QQ？可以手动添加QQ群：439648667');
  void checkUpdate() async => await canLaunch(ConstList.APPSTORE_URL)
      ? await launch(ConstList.APPSTORE_URL)
      : await showSendDialog(context, '跳转失败', '唤起异常，请移步至AppStore');
}
