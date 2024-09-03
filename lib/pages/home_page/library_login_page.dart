import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/library_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/login_button.dart';
import 'package:wust_helper_ios/widget/login_input_widget.dart';

/*
 * 图书馆登陆页面
 * 
 * 和登陆页面相同，以后可以合并一下
 */

class LibraryLoginPage extends StatefulWidget {
  const LibraryLoginPage({Key key}) : super(key: key);

  @override
  State<LibraryLoginPage> createState() => _LibraryLoginPageState();
}

class _LibraryLoginPageState extends State<LibraryLoginPage> {
  double height, screenWidth;
  String stuNum;
  TextEditingController _textEditingController = TextEditingController();
  bool isLoad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    height = ScreenUtil.getInstance().screenHeight;
    screenWidth = ScreenUtil.getInstance().screenWidth;
    stuNum = JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator0);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: ListView(
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
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                "图书馆登陆",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "学号",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              stuNum,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "图书馆密码",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                                hintText: "请输入图书馆密码",
                                fillColor: Colors.grey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            cursorColor: Colors.black,
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 45),
                      child: LoginButton("登录", true, () async {
                        HubUtil.show(msg: "正在登陆图书馆...");
                        bool isSuccess =
                            await libraryLogin(_textEditingController.text);
                        HubUtil.dismiss();
                        if (isSuccess) {
                          BaseCache.getInstance()
                              .setBool(LibraryConst.isLogin, true);
                          BaseNavigator.getInstance()
                              .onJumpTo(RouteStatus.libraryHomePage);
                        }
                      }),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            '默认密码为教务处密码',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 30, right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
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
                isLoad
                    ? Center(
                        child: showLoadingDialog(),
                      )
                    : Container(),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '领航工作室 x 武科大图书馆',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    )),
                // isLoading ? showLoadingDialog() : Container()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
