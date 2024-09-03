import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/admin_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/login_util.dart';
import 'package:wust_helper_ios/util/mini.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/%20switch_button.dart';
import 'package:wust_helper_ios/widget/login_button.dart';
import 'package:wust_helper_ios/widget/login_input_widget.dart';

class LoginPage extends StatefulWidget {
  // List<String> courses;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginEnable = false; // 登录按键许可标识
  String stuNum;
  String jwcPwd;
  var listener;
  bool isLoading = false;
  //默认是本科生登陆
  int loginIndex = 0;

  @override
  void initState() {
    BaseNavigator.getInstance().addListener(this.listener = (current, pre) {});
    super.initState();
  }

  @override
  void dispose() {
    BaseNavigator.getInstance().removeListener((this.listener));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    //用于判断登录方式（目前登录方式： 本科生or研究生）

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: ListView(
          children: [
            Container(
              height: height - height * 0.088,
              child: Stack(children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.35,
                      width: 0.8 * screenWidth,
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 5, left: 60),
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Image.asset(
                                          'assets/images/icon-1024.png'),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "武科大助手",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "随时随地 开启校园之旅",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: ToggleSwitch(
                                  initialLabelIndex: loginIndex,
                                  minWidth: height * 0.17,
                                  cornerRadius: 15.0,
                                  activeBgColor: Colors.green[400],
                                  activeTextColor: Colors.white,
                                  inactiveBgColor: Colors.grey[400],
                                  inactiveTextColor: Colors.black87,
                                  labels: ['本科生', '研究生'],
                                  onToggle: (index) {
                                    //保存当前登陆的方式
                                    //本科生->0  研究生->1  方便后期加登录方式
                                    BaseCache.getInstance()
                                        .setInt(JwcConst.loginIndex, index);
                                    loginIndex = index;
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LoginInput(
                      "一卡通号",
                      "请输入教务处学号",
                      onChanged: (value) {
                        stuNum = value;
                        _checkedEnable();
                      },
                      keyboardType: TextInputType.number,
                    ),
                    LoginInput(
                      "教务密码",
                      "输入教务处密码",
                      onChanged: (value) {
                        jwcPwd = value;
                        _checkedEnable();
                      },
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '登录即表示您同意《武科大助手用户协议》',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 45),
                      child: LoginButton("登录", loginEnable, () async {
                        // setState(() {
                        //   isLoading = true;
                        // });
                        //登陆请求并获取课表
                        List<String> courses;
                        bool hasGotInfo;
                        HubUtil.show(msg: "登陆中...");
                        //进行登陆
                        bool loginSuccessed =
                            await sendLoginRequest(stuNum, jwcPwd, loginIndex);
                        HubUtil.dismiss();
                        //登陆成功
                        if (loginSuccessed) {
                          HubUtil.show(msg: "登陆成功,正在获取课表...");
                          //获取课表
                          courses = await sendCoursesRequest(
                              context, loginIndex,
                              toastGravity: ToastGravity.BOTTOM);
                          //获取学生信息
                          hasGotInfo =
                              await sendInfoRequest(context, loginIndex);
                          if (courses != null && hasGotInfo) {
                            String token = TokenProvider().token;
                            await getAdminNotice(token);
                            await updateMiniProgram(context, courses);
                            await checkVersion(token);
                            BaseNavigator.getInstance().onJumpTo(
                                RouteStatus.navigator2,
                                args: {JwcConst.courses: courses});
                          }
                          HubUtil.dismiss();
                        }

                        // setState(() {
                        //   isLoading = false;
                        // });
                      }),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            '默认密码为学号或身份证后六位',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 30, right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: handleCantLogin,
                              child: Text(
                                '登录遇到问题？',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Text(
                          //   'CopyRight @',
                          //   style: TextStyle(color: Colors.grey, fontSize: 12),
                          // ),
                          Text(
                            'CopyRight @ 领航工作室',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    )),
                isLoading ? showLoadingDialog() : Container()
              ]),
            )
          ],
        ),
      ),
    );
  }

  /// 确定登录键是否可用【学号为12位，密码长度>=6】
  void _checkedEnable() {
    bool enable;
    stuNum.toString().length == 12 && jwcPwd.toString().length >= 6
        ? enable = true
        : enable = false;

    setState(() {
      loginEnable = enable;
    });
  }

  // 无法登陆？
  void handleCantLogin() async {
    bool needJump = await showSendDialog(
          context,
          '无法登录？',
          '加入助手用户反馈群，您的问题我们将在第一时间收到并解决:)',
        ) ??
        false;
    if (needJump) {
      await canLaunch(ConstList.QQ_URL)
          ? await launch(ConstList.QQ_URL)
          : await showSendDialog(context, '跳转失败', '也许您没有安装QQ？烦请手动加群：439648667');
    }
  }
}
