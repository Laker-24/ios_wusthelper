import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universal_html/js.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/graduate_stu_info_model.dart';
import 'package:wust_helper_ios/model/jwc_info_model.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/model/unsccessful_model.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/cache_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/request_util.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:provider/provider.dart';

bool hasLogin() {
  var baseCache = BaseCache.getInstance();
  baseCache.get<bool>(JwcConst.isLogin) ??
      baseCache.setBool(JwcConst.isLogin, false);
  return baseCache.get<bool>(JwcConst.isLogin);
}

/// 发送[登陆]请求
Future<bool> sendLoginRequest(
    String stuNum, String jwcPwd, int loginIndex) async {
  try {
    var result;
    if (loginIndex == 0) {
      result = await JwcDao.commonLogin(stuNum, jwcPwd);

      if (isSuccessful(result)) {
        await commonCache(stuNum, jwcPwd, loginIndex);
        return true;
      } else {
        // String msg = UnsccessfulModel.fromJson(result).msg;
        // showToast(msg);
      }
    } else if (loginIndex == 1) {
      result = await JwcDao.graduateStuLogin(stuNum, jwcPwd);
      if (isSuccessful(result)) {
        await commonCache(stuNum, jwcPwd, loginIndex);
        return true;
      }
    }
    String msg = UnsccessfulModel.fromJson(result).msg;
    if (msg == "success") {
      showToast("登陆成功");
    } else {
      showToast(msg);
    }
  } catch (e) {
    showToast('登陆失败...');
  }
  return false;
}

Future<bool> sendInfoRequest(BuildContext context, int loginIndex) async {
  String token;
  try {
    BaseCache baseCache = BaseCache.getInstance();
    token = baseCache.get<String>(JwcConst.token);
    var result;
    if (loginIndex == 0) {
      result = await JwcDao.getInfo(token);
    } else if (loginIndex == 1) {
      result = await JwcDao.graduateStuInfo(token);
    }

    if (isSuccessful(result) && loginIndex == 0) {
      await baseCache.setString(
          JwcConst.info, json.encode(JwcInfoModel.fromJson(result).data));
      return true;
    } else if (isSuccessful(result) && loginIndex == 1) {
      GraduateStuInfoData data = GraduateStuInfoModel.fromJson(result).data;
      //测试
      // Map<String, dynamic> maps = {
      //   "name": data.name,
      //   "degree": data.degree,
      //   "studentNum": data.studentNum,
      //   "tutorName": data.tutorName,
      //   "academy": data.academy,
      //   "specialty": data.specialty
      // };

      ////202205703009
      await baseCache.setString(JwcConst.info, json.encode(data.toJson()));
      return true;
    }
  } catch (e) {
    showToast('获取学生信息失败！');
  }
  return false;
}

//用于检查token是否失效，若失效则自动登陆进行请求
Future<String> checkToken() async {
  bool needUpdate = false;
  String token;
  try {
    await JwcDao.checkToken();
  } catch (e) {
    needUpdate = true;
  }
  if (needUpdate) {
    //学号密码解密获取
    String stuNum = await JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));

    String jwcPwd = await JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.JWC_PWD));
    //本科生 /研究生
    // int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex);
    int loginIndex = 0;
    var result;
    if (loginIndex == 0) {
      result = await JwcDao.commonLogin(stuNum, jwcPwd);
    } else if (loginIndex == 1) {
      result = await JwcDao.graduateStuLogin(stuNum, jwcPwd);
    }
    token = result['data'];
  }
  return token;
}

//物理实验课表
Future<bool> wlsyLogin(BuildContext context, String stuPwd) async {
  String token = context.read<TokenProvider>().token;
  var result;
  try {
    result = await JwcDao.wlsyLogin(token, stuPwd);
    if (isSuccessful(result)) {
      return true;
    }
    String msg = UnsccessfulModel.fromJson(result).msg;
    showToast(msg);
  } catch (e) {}
  return false;
}
