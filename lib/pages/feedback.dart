/*
 * 
 * 
 * 
 *  兔小巢反馈页面
 * 
 * 
 * 
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with AutomaticKeepAliveClientMixin {
  String baseUrl = 'https://support.qq.com/product/275699?d-wx-push=1';
  int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    String token = context.watch<TokenProvider>().token;

    String url =
        '$baseUrl?t=${DateTime.now().microsecondsSinceEpoch}&token=$token&platform=ios';
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          elevation: 0,
          backgroundColor: appBarColor,
          leading: BackButton(onPressed: () {
            // if (loginIndex == 0)
            //   BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator4);
            // else if (loginIndex == 1)
            //   BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator3);
            Navigator.pop(context);
          }),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
