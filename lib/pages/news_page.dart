import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/login_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

/*
 * 
 *     校园页面
 *  
 */
class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin {
  String baseUrl = 'https://news.wustlinghang.cn';
  String token;
  String url;
  Future future;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    future = initUrl();
    print(future);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    token = context.watch<TokenProvider>().token;

    return SafeArea(
        child: Scaffold(
            body: FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
              )
            : showLoadingDialog();
      },
    )));
  }

  initUrl() async {
    token = await checkToken() ?? TokenProvider().token;
    url =
        '$baseUrl?t=${DateTime.now().microsecondsSinceEpoch}&token=$token&platform=ios';
  }
}
