import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/jwc_info_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareCountdownPage extends StatefulWidget {
  final String uuid;
  final String courseName;
  ShareCountdownPage({Key key, this.uuid, this.courseName}) : super(key: key);

  @override
  State<ShareCountdownPage> createState() => _ShareCountdownPageState();
}

class _ShareCountdownPageState extends State<ShareCountdownPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String stuName = InfoData.fromJson(
            jsonDecode(BaseCache.getInstance().get(JwcConst.info)))
        .stuName;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: countdownColor,
          leading: IconButton(
            onPressed: () => BaseNavigator.getInstance().onJumpTo(
              RouteStatus.countdown,
            ),
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          title: Text(
            '分享倒计时',
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 0.8 * screenWidth,
            height: 0.95 * screenWidth,
            decoration: BoxDecoration(
              color: Colors.grey[300].withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.only(
                left: screenWidth * 0.08,
                top: screenWidth * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenWidth * 0.3 * 0.4,
                        width: screenWidth * 0.3 * 0.4,
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                stuName,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.015 * 2.5,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              widget.courseName,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.015 * 2.2,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  QrImage(
                    data: widget.uuid,
                    size: 230.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenWidth * 0.02, left: 10),
                    child: Text(
                      '扫一扫上方二维码，共享我的倒计时',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
