import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/countdown_model.dart';
import 'package:wust_helper_ios/model/unsccessful_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/request_util.dart';
import 'package:wust_helper_ios/util/toast.dart';

//Jwc返回的token
String token = TokenProvider().token;

///添加倒计时
Future<bool> sendAddCountdownRequest(
    String courseName, String examTime, String notes) async {
  if (notes == null) {
    notes = "无";
  }
  Map countdownArgs = {"name": courseName, "time": examTime, "comment": notes};
  try {
    var result = await JwcDao.addCountdown(token, countdownArgs);
    if (isSuccessful(result)) {
      return true;
    }
  } catch (e) {
    print(e);
  }
  return false;
}

///修改倒计时
Future<bool> modifyCountdownRequest(
    String courseName, String examTime, String notes, String uuid) async {
  Map modifyCountdownArgs = {
    "name": courseName,
    "time": examTime,
    "comment": notes,
    "uuid": uuid
  };
  var result = await JwcDao.modifyCountdown(token, modifyCountdownArgs);
  try {
    if (isSuccessful(result)) {
      return true;
    }
  } catch (e) {
    print(e);
    print(result);
  }
  return false;
}

//查询倒计时
Future<CountdownData> listCountdownRequest() async {
  try {
    var result = await JwcDao.listCountdown(token);
    CountdownData countdownData = CountdownModel.fromJson(result).data;
    if (isSuccessful(result)) {
      return countdownData;
    }
  } catch (e) {
    showToast("查询失败");
  }
  return null;
}

//删除倒计时
Future delCountdownRequest(String uuid) async {
  try {
    var result = await JwcDao.delCountdown(token, {"uuid": uuid});

    if (isSuccessful(result)) {
      print("删除成功");
      return true;
    }
  } catch (e) {
    showToast("查询失败");
  }
  return null;
}

//分享倒计时
Future sharedCountdownRequest(String uuid) async {
  try {
    var result = await JwcDao.sharedCountdown(token, {"uuid": uuid});

    if (isSuccessful(result)) {
      print("删除成功");
      return true;
    }
  } catch (e) {
    showToast("查询失败");
  }
  return null;
}

//获取所有倒计时
getAlltasks() async {
  CountdownData countdownData = await listCountdownRequest();
  return countdownData;
}
