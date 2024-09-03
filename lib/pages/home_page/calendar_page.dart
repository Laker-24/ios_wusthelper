import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';

/*
 * 
 *        校历页面
 *  
 */
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  String baseUrl = 'https://wusthelper.wustlinghang.cn/page/calendar';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String url = baseUrl;
    return Scaffold(
        appBar: AppBar(
          title: Text('校历'),
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
