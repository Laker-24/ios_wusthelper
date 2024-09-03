import 'package:flutter/cupertino.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/get_banner_model.dart';
import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/common.dart';

///发送轮播图请求
Future<List<Data>> sendBannerRequest(BuildContext context) async {
  String token;
  try {
    //BaseCache baseCache = BaseCache.getInstence();
    // token = baseCache.get<String>(JwcConst.token);
    token = TokenProvider().token;
    var result = await JwcDao.getBanner(token);

    BannerModel bannerModel = BannerModel.fromJson(result);
    if (bannerModel.code == 0) {
      return bannerModel.data;
    }
  } catch (e) {}
  return null;
}
