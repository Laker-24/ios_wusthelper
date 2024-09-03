import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:m_loading/m_loading.dart';

showLoadingDialog() {
  return Center(
    child: Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: EdgeInsets.all(45),
          child: CircularProgressIndicator(
            strokeWidth: 6,
          )),
    ),
  );
}

//展示加载动画
// showLoadingDialogBarScale(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BarScale1Loading(
//           color: Colors.black,
//           duration: Duration(minutes: 1),
//           height: 50,
//           width: 50,
//         );
//       });
// }
//加载工具类
class HubUtil {
  static ready() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 40.0
      ..radius = 5.0
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.white
      ..maskType = EasyLoadingMaskType.none
      ..dismissOnTap = false
      ..progressColor = Colors.white
      ..textColor = Colors.black54
      ..userInteractions = false;
  }

  static show({String msg = "加载中...", bool dismissOnTap = false}) {
    EasyLoading.show(status: msg, dismissOnTap: dismissOnTap);
  }

  //toast
  //以后可以直接在这里添加各种toast
  static showSuccess({String msg = "成功"}) {
    EasyLoading.showSuccess(msg);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}
