import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/admin_notice_model.dart';
import 'package:wust_helper_ios/model/version_model.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';

///简述逻辑：
///因为管理端的公告有两个选项“不再提示”“知道了”
///当点击“知道了”就将该公告存入本地，下次继续调用
///当点击“不再提示”就不存入，之后均不调用该公告
showVersionAndNotices(BuildContext context) async {
  List<String> oldNoticeStrs = [];
  List<String> newNoticeStrs = [];
  String versionDataStr = '';
  //获取在本地保存的公告（因为用户没有点击“不再提示”）
  oldNoticeStrs =
      BaseCache.getInstance().getStringList(AdminConst.oldNotices) ?? [];
  //获取管理端的公告
  newNoticeStrs =
      BaseCache.getInstance().getStringList(AdminConst.newNotices) ?? [];
  //是否有失误招领公告
  String lostTips = BaseCache.getInstance().get(ConstList.LOST_TIPS) ?? '';
  //获取最新版本号（管理端添加，为null或者‘ ‘说明未有新版本）
  versionDataStr = BaseCache.getInstance().get<String>(AdminConst.version);
  //判断是否存在管理端公告，存在即执行公告
  if (newNoticeStrs.length != 0 || oldNoticeStrs.length != 0) {
    await showNotices(context, oldNoticeStrs, newNoticeStrs);
  }
  //如果版本号存在即弹出更新公告
  // bool isPrompt = BaseCache.getInstence().get(AdminConst.isPrompt); //是否提示
  if (versionDataStr != null && versionDataStr != '') {
    BaseCache.getInstance().setString(AdminConst.version, '');
    await showVersionData(context, versionDataStr);
  }
  if (lostTips != null && lostTips != '') {
    await showLostTips(context, lostTips);
  }
}

///管理端通知公告
showNotices(BuildContext context, List<String> oldNoticeStrs,
    List<String> newNoticeStrs) async {
  List<AdminNoticeData> oldNoticeData = oldNoticeStrs
      .map((notice) => AdminNoticeData.fromJson(JsonDecoder().convert(notice)))
      .toList();

  List<AdminNoticeData> newNoticeData = newNoticeStrs
      .map((notice) => AdminNoticeData.fromJson(JsonDecoder().convert(notice)))
      .toList();

  /// [判断公告逻辑：]
  /// [本地有，repeat为true]
  /// [服务端有，本地没有]
  /// [相同条件为ID一致]
  List<AdminNoticeData> newList = [];

  /// 将所有旧公告添加进列表
  oldNoticeData.forEach((element) {
    // if (element.repeat == true) {
    newList.add(element);
    // }
  });

  /// 判断新公告是否和当前是同一个，否则添加进列表
  newNoticeData.forEach((newData) {
    bool find = false;
    oldNoticeData.forEach((old) {
      if (newData.newsid == old.newsid) {
        find = true;
      }
    });
    if (!find) {
      newList.add(newData);
    }
  });
  //弹出公告
  for (AdminNoticeData item in newList) {
    if (item.repeat) {
      bool need = await showSendDialog(context, item.title, item.content,
              cancelWord: '不再提示', confirm: '知道了') ??
          true;
      if (!need) {
        item.repeat = false;
      }
    }
  }

  BaseCache.getInstance().setStringList(AdminConst.oldNotices,
      newList.map((e) => JsonEncoder().convert(e.toJson())).toList());
}

//版本更新公告
showVersionData(BuildContext context, String versionDataStr) async {
  VersionData versionData =
      VersionData.fromJson(JsonDecoder().convert(versionDataStr));

  /// 自定义标识[//!must!//]表示需要强制更新
  final String upDateFlag = '//!must!//';
  bool mustUpdate = false;
  bool needUpdate = false;
  if (versionData.updateContent.length >= 7) {
    mustUpdate =
        versionData.updateContent.substring(0, upDateFlag.length) == upDateFlag;
  }
  //判断是否需要进行重要更新
  if (mustUpdate) {
    needUpdate = await showSendDialog(
            context,
            '重要更新',
            //将 [自定义标识]裁剪掉
            versionData.updateContent.replaceAll(upDateFlag, ''),
            cancelWord: '就不更新（会闪退）',
            confirm: '不得不去更新') ??
        false;
    //未点击更新
    if (!needUpdate) {
    }
    //点击了更新
    else {
      await canLaunch(ConstList.APPSTORE_URL)
          ? await launch(ConstList.APPSTORE_URL)
          : await showSendDialog(context, '跳转失败', '唤起异常，请移步至AppStore');
    }
    //直接退出应用
    exit(0);
  }
  //未有重要更新
  else {
    //判断是否进行小更新
    needUpdate = await showSendDialog(
            context, '版本更新公告', versionData.updateContent,
            cancelWord: '我知道了', confirm: '这就更新') ??
        false;
  }
  //若进行小更新，跳转app
  if (needUpdate) {
    await canLaunch(ConstList.APPSTORE_URL)
        ? await launch(ConstList.APPSTORE_URL)
        : await showSendDialog(context, '跳转失败', '唤起异常，请移步至AppStore');
  }
  //点击不再提示，则将当前需要更新的版本进行本地缓存，若下次缓存版本号与需更新的版本号相同，则不进行弹窗
  // else {
  //   BaseCache.getInstence().setBool(AdminConst.isPrompt, false);
  // }
}

///失物招领公告
showLostTips(BuildContext context, String lostTips) async {
  Map<String, String> data = json.decode(lostTips);
  bool need = await showSendDialog(context, data['title'], data['content'],
          cancelWord: '不再提示', confirm: '知道了') ??
      false;
  //不再提示后，发起请求，后台会删除该条招领信息
  if (!need) {
    String token = BaseCache.getInstance().get(JwcConst.token);
    await JwcDao.getLostTipsRead(token);
  }
}
