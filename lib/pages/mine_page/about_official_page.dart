import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/util/common.dart';

/// [官网页面]
class AboutOfficialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('领航工作室官网'), backgroundColor: appBarColor),
      body: WebView(
        initialUrl: 'https://wustlinghang.cn',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
