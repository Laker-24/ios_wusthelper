/*
 * 
 * 
 * 志愿者页面
 * //https://volunteer.wustlinghang.cn
 * 
 * 
 */
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/login_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

import 'dart:convert';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VolunteerPage extends StatefulWidget {
  @override
  _VolunteerPageState createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage>
    with AutomaticKeepAliveClientMixin {
  String baseUrl = 'https://volunteer.wustlinghang.cn';

  String token;
  String url;
  Future future;
  WebViewController controller;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    future = initUrl();
  }

  Future<bool> _saveBase64ImageToGallery(String message) async {
    try {
      // 将base64格式的图片转换为Uint8List类型的数据
      final Uint8List imageData = base64.decode(message.split(',')[1]);

      // 将图片保存到相册中
      final result = await ImageGallerySaver.saveImage(imageData);
      return true;
      // if (result) showLoadingDialog();
    } on PlatformException catch (error) {
      print('Error saving image to gallery: ${error.message}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    token = context.watch<TokenProvider>().token;
    WebViewController _controller;
    return SafeArea(
        child: Scaffold(

            /// `因为前端的页面加了返回键，就不需要这个appBar了（但我舍不得删）`
            // appBar: AppBar(
            //   leading: IconButton(
            //       icon: Icon(
            //         Icons.home,
            //         color: Color.fromRGBO(46, 108, 246, 0.7),
            //       ),
            //       onPressed: tapEnable
            //           ? () {
            //               setState(() {
            //                 isReLoad = true;
            //                 tapEnable = false;
            //               });
            //               Future.delayed(Duration(milliseconds: 50), () {
            //                 setState(() {
            //                   isReLoad = false;
            //                 });
            //               });
            //               Future.delayed(Duration(seconds: 3), () {
            //                 setState(() {
            //                   tapEnable = true;
            //                 });
            //               });
            //               /// 防止有人拼命点击，一分钟最多点10次
            //               if (tapNum == 0)
            //                 Future.delayed(Duration(minutes: 1), () {
            //                   setState(() {
            //                     tapEnable = true;
            //                     tapNum = 0;
            //                   });
            //                 });
            //               tapNum++;
            //               if (tapNum >= 10) {
            //                 tapEnable = false;
            //               }
            //             }
            //           : () {
            //               if (tapNum >= 10) showToast('您的点击太过频繁，请休息一下:)');
            //             }),
            //   title: Text('工时系统'),
            //   elevation: 0,
            //   backgroundColor: appBarColor,
            // ),
            body: FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onPageFinished: (url) {
                  String cookie = "token=$token;domain=wustlinghang.cn;path=/";
                  _controller.evaluateJavascript(cookie);
                },
                javascriptChannels: <JavascriptChannel>[
                  JavascriptChannel(
                      name: 'VueToFlutter',
                      onMessageReceived: (JavascriptMessage message) async {
                        HubUtil.show(msg: "正在保存证书...");
                        // print("收到的参数传入："); //String Hello,Flutter
                        Future.delayed(Duration(seconds: 3));
                        if (await _saveBase64ImageToGallery(message.message)) {
                          HubUtil.dismiss();
                          HubUtil.showSuccess(msg: "保存成功!");
                        }
                      }),
                ].toSet(),
              )
            : showLoadingDialog();
      },
    )));
  }

  initUrl() async {
    token = await checkToken() ?? TokenProvider().token;
    url =
        '$baseUrl?t=${DateTime.now().microsecondsSinceEpoch}&token=$token&platform=ios';

    // print("a" * 20);

    // print(DateTime.now().microsecondsSinceEpoch);
    // print(token);
  }
}
