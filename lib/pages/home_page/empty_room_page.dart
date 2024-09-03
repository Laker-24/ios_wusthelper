import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';

class EmptyRoomPage extends StatefulWidget {
  @override
  _EmptyRoomPageState createState() => _EmptyRoomPageState();
}

class _EmptyRoomPageState extends State<EmptyRoomPage>
    with AutomaticKeepAliveClientMixin {
  String baseUrl = 'https://wustlinghang.cn/class/emptyroom';

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
          // backgroundColor: appBarColor,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
// 'https://wustlinghang.cn/class/emptyroom'
