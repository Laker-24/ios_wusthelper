import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BannerContentPage extends StatefulWidget {
  final String contentUrl;
  const BannerContentPage(this.contentUrl, {Key key}) : super(key: key);

  @override
  _BannerContentPageState createState() => _BannerContentPageState();
}

class _BannerContentPageState extends State<BannerContentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          // title: Text('广告'),
          elevation: 0,
        ),
        body: WebView(
          initialUrl: widget.contentUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
