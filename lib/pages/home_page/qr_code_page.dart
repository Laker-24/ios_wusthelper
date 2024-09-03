import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/jwc_info_model.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({Key key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage>
    with AutomaticKeepAliveClientMixin {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  //全局key-截图key
  final GlobalKey boundaryKey = GlobalKey();
  Future future;

  String stuName;
  String stuNum;
  String token;
  String semester;

  @override
  void initState() {
    super.initState();
    future = _memoizer.runOnce(() async {
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    super.build(context);
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        {}
        return Scaffold(
          appBar: AppBar(
            title: Text("情侣课表"),
            backgroundColor: Colors.pink[100],
          ),
          body: RepaintBoundary(
            key: boundaryKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.015 * 10,
                          height: screenWidth * 0.015 * 10,
                          child: InkWell(
                            child: Image.asset(
                              'assets/images/avatar.png',
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2, bottom: 5, right: 5),
                                    child: Text(
                                      stuName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.015 * 4.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                semester,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.015 * 3.2,
                                    color: Colors.black26),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                      child: QrImage(
                    data: encode(stuName, stuNum, token, semester),

                    // foregroundColor: Colors.pink[800],
                  )),
                ],
              ),
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              height: 45,
              onPressed: () async {
                if (await _captureImage()) {
                  HubUtil.dismiss();
                  HubUtil.showSuccess(msg: "保存成功!");
                }
              },
              disabledColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "保存到相册",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.save,
                    color: Colors.white,
                  )
                ],
              ),
              color: Colors.pink[200],
            ),
          ),
        );
      },
    );
  }

  String encode(
      String studentName, String studentId, String token, String semester) {
    Random random = new Random();
    String content = "kjbk" +
        "?+/" +
        studentName +
        "?+/" +
        studentId +
        "?+/" +
        token +
        "?+/" +
        semester;
    print(content);
    content = base64.encode(utf8.encode(content));
    content = (100 + random.nextInt(799)).toString() +
        content.substring(0, 7) +
        (100 + random.nextInt(799)).toString() +
        content.substring(7);

    return content;
  }

  Future<bool> _captureImage() async {
    try {
      RenderRepaintBoundary boundary =
          boundaryKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 2);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      return true;
      // if (result) showLoadingDialog();
    } on PlatformException catch (error) {
      print('Error saving image to gallery: ${error.message}');
      return false;
    }
  }

  initData() async {
    stuNum = await JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
    stuName = await InfoData.fromJson(
            jsonDecode(BaseCache.getInstance().get(JwcConst.info)))
        .stuName;
    token = await JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(JwcConst.token));
    semester = await JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(JwcConst.currentTerm));
  }

  @override
  bool get wantKeepAlive => true;
}
