import 'dart:convert';

import 'package:package_info/package_info.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/core/hi_error.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/admin_notice_model.dart';
import 'package:wust_helper_ios/model/lost_tips_model.dart';
import 'package:wust_helper_ios/model/version_model.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/toast.dart';

/// [检查版本号]
/// [版本号为x.y.z，只要x.y相等（即大版本相同），即默认不弹出更新窗口，使用公共进行弹窗提示用户]
///[因为在不进行大的调整（如更换框架）的情况下，x最好不要改变，故在此不做判断x是否一致]
///[如果y发生的改动（一般为增加新功能）]
///[如果z发生了改动（bug修复，小组件异常啦，部分组件变动）]
Future<void> checkVersion(String token) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // 本地当前版本号
  String baseVersion = packageInfo.version;
  try {
    //从管理端获取当前最新版本（自己要去管理端设置，不要忘了哦～）
    var result = await JwcDao.getVersion(token);
    VersionData versionData = VersionModel.fromJson(result).data;
    // 最新版本号
    String latestVersion = versionData.version;
    if (baseVersion.substring(2, 4) != latestVersion.substring(2, 4)) {
      BaseCache.getInstance().setString(
          AdminConst.version, JsonEncoder().convert(versionData.toJson()));
    }
  } catch (e) {
    showToast('网络不佳诶～');
  }
}

/// [获取管理端公告]
Future<void> getAdminNotice(String token) async {
  try {
    var result = await JwcDao.getNotice(token);
    List<AdminNoticeData> noticeDatas = AdminNoticeModel.fromJson(result).data;
    List<String> noticeStrList = [];

    if (noticeDatas != []) {
      noticeStrList = noticeDatas
          .map((element) => JsonEncoder().convert(element.toJson()))
          .toList();
      await BaseCache.getInstance()
          .setStringList(AdminConst.newNotices, noticeStrList);
    }
  } on HiNetError {}
}

/// [获取失物招领公告]
Future<void> getLostTips(String token) async {
  try {
    var result = await JwcDao.getLostTipsUnRead(token);
    Map<String, String> data = LostTipsModel.fromJson(result).data;
    if (LostTipsModel.fromJson(result).data != null) {
      BaseCache.getInstance().setString(ConstList.LOST_TIPS, json.encode(data));
    } else {
      BaseCache.getInstance().setString(ConstList.LOST_TIPS, '');
    }
  } on HiNetError {}
}
