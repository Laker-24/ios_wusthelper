import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/db/base_cache.dart';

import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/credit_model.dart';

import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/util/toast.dart';

/*
 *         原学分统计页面 
 *          现在是培养方案
 * 
 */
class CreditPage extends StatefulWidget {
  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  // WebViewController _creditController;
  WebViewController _trainingController;
  //学分统计html
  // String creditHtml;
  //培养方案html
  String traingingHtml;
  int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("培养方案"),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: _send(context, loginIndex),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? WebView(
                  initialUrl: '',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _trainingController = controller;
                    _loadHtml();
                  },
                )
              : Center(
                  child: showLoadingDialog(),
                );
        },
      ),
    );
  }

  _send(BuildContext context, int loginIndex) async {
    String token = context.read<TokenProvider>().token;
    String data = BaseCache.getInstance().get(JwcConst.trainingHtml);
    int preRequestMonth =
        BaseCache.getInstance().get<int>(JwcConst.traingingRequestTime) ?? -1;
    //设置为每个月可请求一次，当月多次请求使用本地缓存
    if (data != null && (DateTime.now().month == preRequestMonth)) {
      traingingHtml = data;
      return;
    }

    try {
      //以前是学分统计，因教务处更替，暂时舍弃
      // var creditResult;
      var trainingResult;
      if (loginIndex == 0) {
        // creditResult = await JwcDao.getTraining(token);
        trainingResult = await JwcDao.getTraining(token);
      } else if (loginIndex == 1) {
        trainingResult = await JwcDao.graduateStuTraining(token);
      }
      // 因为model一样所以复用了一下下QAQ，感觉没必要创建model其实
      // creditHtml = CreditModel.fromJson(trainingResult).data;
      traingingHtml = CreditModel.fromJson(trainingResult).data;
      //将培养方案保存到本地
      BaseCache.getInstance().setString(JwcConst.trainingHtml, traingingHtml);
      //请求的月份
      BaseCache.getInstance()
          .setInt(JwcConst.traingingRequestTime, DateTime.now().month);
    } catch (e) {
      showToast('网络不佳诶 TT');
    }
  }

  _loadHtml() async {
    _trainingController.loadUrl(Uri.dataFromString(traingingHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  // showHtml(int index) {
  //   if (index == 0) {
  //     if (creditHtml != null) {
  //       _creditController.loadUrl(Uri.dataFromString(creditHtml,
  //               mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //           .toString());
  //     }
  //   }
  // else if (index == 1) {
  //   if (traingingHtml != null) {
  //     _trainingController.loadUrl(Uri.dataFromString(traingingHtml,
  //             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //         .toString());
  //   }
  // }
  // }
}

//       WebView(
//         initialUrl: '',
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (controller) {
//           _creditController = controller;
//           showHtml(0);
//         },
//       ),
//     ),
//     // traingingHtml != null
//     //     ? SizedBox.expand(
//     //         child: SingleChildScrollView(
//     //           child: WebView(
//     //             initialUrl: '',
//     //             javascriptMode: JavascriptMode.unrestricted,
//     //             onWebViewCreated: (controller) {
//     //               _trainingController = controller;
//     //               showHtml(1);
//     //             },
//     //           ),
//     //         ),
//     //       )
//     //     : Container(),
//   ],
