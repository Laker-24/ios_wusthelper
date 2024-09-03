import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/jwc_combine_model.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'common.dart';

//貌似没用吗～QAQ    sannpai～
Future<List<String>> combineCache(
    result, String stuNum, String jwcPwd, BuildContext context) async {
  BaseCache baseCache = BaseCache.getInstance();
  //
  JwcCombineModel jwcCombineModel = JwcCombineModel.fromJson(result);
  List<String> courses = jwcCombineModel.data.courses
      .map<String>((course) => json.encode(course.toJson()))
      .toList();

  await baseCache
      .setString(ConstList.STU_NUM, stuNum)
      .setString(ConstList.JWC_PWD, jwcPwd)
      .setStringList(JwcConst.courses, courses)
      .setString(JwcConst.info, json.encode(jwcCombineModel.data.info.toJson()))
      .setBool(JwcConst.isLogin, true);

  await setCourseColor(courses, context);
  return courses;
}

//保存学号和密码
Future<bool> commonCache(String stuNum, String jwcPwd, int loginIndex) async {
  BaseCache baseCache = BaseCache.getInstance();
  try {
    //对密码进行AES256加密
    await baseCache
        .setString(ConstList.STU_NUM, JhEncryptUtils.aesEncrypt(stuNum))
        .setString(ConstList.JWC_PWD, JhEncryptUtils.aesEncrypt(jwcPwd))
        .setBool(JwcConst.isLogin, true)
        .setInt(JwcConst.loginIndex, loginIndex);
  } catch (e) {
    return false;
  }
  return true;
}
