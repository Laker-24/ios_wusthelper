import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';

class LostPage extends StatefulWidget {
  @override
  _LostPageState createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  String baseUrl = 'https://lost.wustlinghang.cn';
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    String token = context.watch<TokenProvider>().token;
    String url =
        '$baseUrl?t=${DateTime.now().microsecondsSinceEpoch}&token=$token&platform=ios';
    return Scaffold(
        appBar: AppBar(
          title: Text('失物招领'),
          // backgroundColor: appBarColor,
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onPageFinished: (url) {
            String cookie = "token=$token;domain=wustlinghang.cn;path=/";
            _controller.evaluateJavascript(cookie);
          },
        ));
  }
}
