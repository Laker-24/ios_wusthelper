import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';

/// 扫码页面

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  StateSetter stateSetter;

  IconData lightIcon = Icons.flash_on;
  int loginIndex;
  bool isMonday;
  ScanController controller = ScanController();
  String stuNum;

  // initData() async {
  //   stuNum = await JhEncryptUtils.aesDecrypt(
  //       BaseCache.getInstance().get(ConstList.STU_NUM));
  //   isMonday =
  //       BaseCache.getInstance().get(ScheduleConst.currentMondayTime) ?? true;
  //   loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
  // }
  @override
  void initState() {
    stuNum = JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
    isMonday =
        BaseCache.getInstance().get(ScheduleConst.currentMondayTime) ?? true;
    loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
    super.initState();
  }

  QRScannerPageConfig config =
      QRScannerPageConfig(scanAreaSize: 0.8, scanLineColor: wustHelperBlue);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            MaterialButton(
                child: Icon(
                  Icons.image,
                  size: 30,
                  color: wustHelperBlue.withOpacity(0.5),
                ),
                onPressed: () async {
                  // initData();
                  pickImage();
                }),
          ],
        ),
        body: ScanView(
          controller: controller,
          scanAreaScale: config.scanAreaSize,
          scanLineColor: config.scanLineColor,
          onCapture: (String data) async {
            // initData();
            dealData(data);
          },
        ));
  }

// BaseNavigator.getInstance();
  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String data = await Scan.parse(image.path);
      dealData(data);
    }
  }

  dealData(String data) async {
    setState(() {
      data = data.substring(3, 10) + data.substring(13);
      data = utf8.decode(base64.decode(data));
      List<String> strs = data.split("?+/");
      //转到qr_code_page的encode
      if (stuNum == strs[2]) {
        showToast("请也不要添加自己的～", toastGravity: ToastGravity.CENTER);
        BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator2);
      } else {
        Future<bool> sendCP = showSendDialog(
                context,
                '确认要添加',
                "姓名:" +
                    strs[1] +
                    "\n" +
                    "学号:" +
                    strs[2] +
                    "\n" +
                    strs[4] +
                    "学期的课表吗？") ??
            false;
        sendCP.then((value) {
          if (value) {
            HubUtil.show(msg: "正在更新课程表", dismissOnTap: true);
            sendCPCoursesRequest(context, loginIndex, strs[3],
                    isMonday: isMonday)
                .then((value) => BaseNavigator.getInstance()
                    .onJumpTo(RouteStatus.navigator2))
                .then((value) {
              HubUtil.dismiss();
            }); //这里直接跳出来会导致导入课表失败

          } else
            BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator2);
        });
      }
    });
  }

  // Widget _buildScanner() {
  //   QRScannerPageConfig config =
  //       QRScannerPageConfig(scanAreaSize: 0.8, scanLineColor: wustHelperBlue);
  //   return ScanView(
  //     controller: controller,
  //     scanAreaScale: config.scanAreaSize,
  //     scanLineColor: config.scanLineColor,
  //     onCapture: (String data) async {
  //       sendCPCoursesRequest(context);
  //     },
  //   );
  // }
}
//   Future pickImage() async {
//     List<Media> files = await ImagesPicker.pick(
//       pickType: PickType.image,
//       count: 9,
//     );
//     if (files != null && files.isNotEmpty) {
//       for (int i = 0; i < files.length; i++) {
//         String value = await Scan.parse(files[i].path);
//         result.add(value);
//       }
//       showResult(content: result.toString());
//     }
//   }
// }

class QRScannerPageConfig {
  double scanAreaSize;
  Color scanLineColor;

  QRScannerPageConfig({this.scanAreaSize, this.scanLineColor});
}

class DividerHorizontal extends StatelessWidget {
  final double height;
  final Color color;

  DividerHorizontal({this.height: 1, this.color: const Color(0xFFF8F9F8)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
    );
  }
}
