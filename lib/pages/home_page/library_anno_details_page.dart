import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/library_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';

class LibraryAnnoDetailsPage extends StatefulWidget {
  final int announcementId;
  const LibraryAnnoDetailsPage(this.announcementId, {Key key})
      : super(key: key);

  @override
  State<LibraryAnnoDetailsPage> createState() => _LibraryAnnoDetailsPageState();
}

class _LibraryAnnoDetailsPageState extends State<LibraryAnnoDetailsPage> {
  Future _future;
  String _url = " ";
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _future = _getAnnoDetailsUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.white,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              Widget _widget;
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _widget = _url != " "
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 5.0, right: 20, left: 20),
                          child: WebView(
                            initialUrl: '',
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated: (controller) {
                              _webViewController = controller;
                              _loadHtml();
                            },
                          ),
                        )
                      : Center(
                          child: Text("加载失败，请检查您的网络~"),
                        );
                  break;
                case ConnectionState.waiting:
                  _widget = showLoadingDialog();
                  break;
                case ConnectionState.none:
                  _widget = Center(
                    child: Text("加载失败，请检查您的网络~"),
                  );
                  break;
                default:
              }
              return _widget;
            }));
  }

  _getAnnoDetailsUrl() async {
    _url = await getLibraryAnnoDetailsUrl(widget.announcementId);
  }

  _loadHtml() async {
    //避免加载在ios上文本过小
    String htmlStr = """<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 0; padding: 0;'>
        <div>
          ${_url}
        </div>
      </body>
    </html>""";
    _webViewController.loadUrl(Uri.dataFromString(htmlStr,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

String a = '''
<table> 
 <tbody>
  <tr> 
   <td style="padding: 20px 0 10px 0; height:100%;"> 
    <!--标题 --> 
    <div style="font-size: 14px; font-weight: bolder;  margin: 20px; text-align :center;width:80%">
      起点考研网开通使用 
    </div> 
    <!--附加信息 --> 
    <div style="width:80%;padding-left:220px"> 
     <div style="float: left;">
       发布日期： 2021-02-26 
     </div> 
     <div style="float: left;">
       &nbsp;&nbsp;&nbsp;&nbsp;发布者 admin 
     </div> 
    </div> 
    <!--正文 --> 
    <div style="clear: both; font-size: 13px; line-height: 28px; padding-right: 70px;"> 
     <p>《起点考研网》是北京智联起点信息技术有限公司与北京理工大学出版社、人民大学出版社、跨考教育集团等国内知名出版及培训机构合作开发的精品考研辅导视频课程。</p>
     <p></p>
     <p>本网视频课程分为公共课、统考专业、专业硕士三大类，包括：</p>
     <p></p>
     <p>公共课：考研政治、考研英语一、考研英语二、考研数学、管理类综合、经济类综合；</p>
     <p></p>
     <p>统考课：计算机、教育学、心理学、法律硕士、历史学、西医综合；</p>
     <p></p>
     <p>非统考：金融硕士、翻译硕士、管理学、经济学、新闻传播。</p>
     <p></p>
     <p><strong>访问方式</strong></p>
     <p></p>
     <p>校园网用户</p>
     <p></p>
     <p>在校园网IP范围内登陆《起点考研网》（<a href="http://www.yjsexam.com.wust.dr2am.cn/">http://www.yjsexam.com</a>）即可使用；</p>
     <p></p>
     <p>手机用户</p>
     <p></p>
     <p>1、校内关注“起点考试”微信公众平台；</p>
     <p></p>
     <p>2、进入公众微信号后，点击下方菜单“起点考研”，选择“考研网”；</p>
     <p></p>
     <p>3、点击“注册新用户”按钮，根据提示选择学校：湖北-武汉科技大学；</p>
     <p></p>
     <p>4、用户名设置为学号，输入手机号码/邮箱，设置登陆密码，注册成功，即可开始学习。（校内注册，校外即可使用。）</p>
     <p></p>
     <p> </p>
    </div> </td> 
  </tr> 
  <tr>
   <td align="center"><img src="../imge/扫描关注.jpg" width="30%" height="25%" alt=""><br> <br></td>
  </tr> 
  <tr> 
   <td style="margin: 20px 0 20px 0; "> </td> 
  </tr> 
  <tr> 
   <td style="margin: 20px 0 20px 0; "> 
    <!--标题 --> 下一条：<a class="other" href="bulletDetail.aspx?bulletid=16331"> EPS数据平台开通使用 </a> </td> 
  </tr> 
  <tr> 
   <td><br></td> 
  </tr> 
 </tbody>
</table>
''';
