import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';

/// [关于软件页面]

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo packageInfo;
  int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('关于软件'),
          backgroundColor: appBarColor),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.22,
                    height: width * 0.22,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  FutureBuilder(
                      future: getVersion(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.done
                              ? Text(
                                  'v${packageInfo.version}',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.015 * 2.7),
                                )
                              : Text(
                                  '正在查询版本号..',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.015 * 2.7),
                                )),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10, bottom: 5),
                  //   child: Text(
                  //     '武汉科技大学教务处唯一授权',
                  //     style: TextStyle(
                  //         color: Colors.black54,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: width * 0.015 * 2.3),
                  //   ),
                  // ),
                  Text(
                    '欢迎关注新武科大助手微信公众号',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontSize: width * 0.015 * 2.3),
                  )
                ],
              ),
            ),
            SizedBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '作者',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.015 * 3),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    child: GestureDetector(
                        onTap: () => BaseNavigator.getInstance()
                            .onJumpTo(RouteStatus.aboutAuthor),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.08,
                                height: width * 0.08,
                                child: Image.asset('assets/images/GitHub.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  '作者介绍',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: width * 0.015 * 2.7),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                Text(
                  '其他',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.015 * 3),
                ),
                SizedBox(
                  child: GestureDetector(
                      onTap: () => BaseNavigator.getInstance()
                          .onJumpTo(RouteStatus.aboutOffical),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.08,
                              height: width * 0.08,
                              child: Image.asset('assets/images/工作.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                '领航工作室官网',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.015 * 2.7),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
