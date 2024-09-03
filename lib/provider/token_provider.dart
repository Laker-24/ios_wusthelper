import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class TokenProvider extends ChangeNotifier {
  String get token => BaseCache.getInstance().get(JwcConst.token);
  setToken(String token) {
    BaseCache.getInstance().setString(JwcConst.token, token);
  }
}
